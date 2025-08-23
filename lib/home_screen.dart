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
    _postsFuture = _loadPostsData();
    _wordsFuture = _loadUnknownWords();
  }

  Future<List<dynamic>> _loadPostsData() async {
    final String jsonString =
      await rootBundle.loadString('assets/selected_posts.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList;
  }

  Future<List<dynamic>> _loadUnknownWords() async {
    final String jsonString =
      await rootBundle.loadString('assets/voca_user.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    if (jsonList.length <= 3) {
      return jsonList;
    }
    jsonList.shuffle(Random());
    return jsonList.take(3).toList();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_postsFuture, _wordsFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (snapshot.hasData) {
          final results = snapshot.data as List<dynamic>;
          final postData = results[0] as List<dynamic>;
          final wordList = results[1] as List<dynamic>;
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: postData.length,
            itemBuilder: (context, index) {
              final post = postData[index] as Map<String, dynamic>;
              var pair = randomColor();
              if (index == 0 || index % 5 != 0) {
                return PostWidget(
                  post: post,
                  backgroundColor: pair.backgroundColor,
                  textColor: pair.textColor
                );
              } else {
                return QuizWidget(words: wordList);
              }
            },
          );
        }
        else {
          return const Center(child: Text('No posts found.'));
        }
      },
    );
  }
}
