import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _postsFuture;

  @override
  void initState() {
    super.initState();
    // Load post data from the JSON asset when the widget is first created
    _postsFuture = _loadPostsData();
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

  @override
  Widget build(BuildContext context) {
    // CHANGE: Removed the Scaffold and AppBar as they are now in MainScreen
    return FutureBuilder<List<dynamic>>(
      future: _postsFuture,
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
          final postData = snapshot.data!;
          return PageView.builder(
            scrollDirection: Axis.vertical, // Set scroll direction to vertical.
            //physics: const FastScrollPhysics(),
            itemCount: postData.length,
            itemBuilder: (context, index) {
              // Ensure the post is a Map before passing it to the widget
              final post = postData[index] as Map<String, dynamic>;
              return PostWidget(post: post);
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
