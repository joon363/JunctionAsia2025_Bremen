import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz_widget.dart';
import 'post_widget.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _postsFuture;
  late Future<List<dynamic>> _wordsFuture;

  @override
  void initState() {
    super.initState();
    // Load post data from the JSON asset when the widget is first created
    _postsFuture = _loadPostsData();
    _wordsFuture = _loadUnknownWords();
  }

  // Asynchronously loads and decodes post data from a JSON file in the assets.
  Future<List<dynamic>> _loadPostsData() async {
    // Load the JSON string from the asset bundle
    final String jsonString =
      await rootBundle.loadString('assets/selected_posts.json');
    // Decode the JSON string into a List
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList;
  }

  Future<List<dynamic>> _loadUnknownWords() async {
    // Load the JSON string from the asset bundle
    final String jsonString =
    await rootBundle.loadString('assets/voca_user.json');
    // Decode the JSON string into a List
    final List<dynamic> jsonList = json.decode(jsonString);
    if (jsonList.length <= 3) {
      // 요소가 3개 이하라면 그대로 반환
      return jsonList;
    }
    jsonList.shuffle(Random()); // 리스트 순서를 랜덤으로 섞음
    return jsonList.take(3).toList(); // 앞에서 3개 추출
  }
  @override
  Widget build(BuildContext context) {
    // CHANGE: Removed the Scaffold and AppBar as they are now in MainScreen
    return FutureBuilder(
      future: Future.wait([_postsFuture,_wordsFuture]),
      builder: (context, snapshot) {
        // Show a loading indicator while data is being fetched
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Show an error message if data loading fails
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Once data is successfully loaded, build the list of posts
        else if (snapshot.hasData) {
          final results = snapshot.data as List<dynamic>;
          final postData = results[0] as List<dynamic>;
          final wordList = results[1] as List<dynamic>;
          return PageView.builder(
            scrollDirection: Axis.vertical, // Set scroll direction to vertical.
            //physics: const FastScrollPhysics(),
            itemCount: postData.length,
            itemBuilder: (context, index) {
              // Ensure the post is a Map before passing it to the widget
              final post = postData[index] as Map<String, dynamic>;
              var pair = RandomColor();
              if(index==0||index%5!=0) {
                return PostWidget(
                    post: post,
                    backgroundColor: pair.backgroundColor,
                    textColor: pair.textColor
                );
              } else{
                return QuizWidget(words: wordList);
              }
            },
          );
        }
        // Show a generic message if there's no data for some reason
        else {
          return const Center(child: Text('No posts found.'));
        }
      },
    );
  }
}

class FastScrollPhysics extends ScrollPhysics {
  const FastScrollPhysics({super.parent});

  @override
  FastScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // offset을 늘리면 스와이프 감속이 더 빨라짐
    return offset * 2.0;
  }
}
