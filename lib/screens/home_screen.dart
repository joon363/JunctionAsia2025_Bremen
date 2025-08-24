import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/end_widget.dart';
import '../theme.dart';

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
      await rootBundle.loadString('assets/datas/kpop_posts.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList;
  }

  Future<List<dynamic>> _loadUnknownWords() async {
    final String jsonString =
      await rootBundle.loadString('assets/datas/voca_user.json');
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
          return Scaffold(
              appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text('Feed',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                        ),
                      ),
                      EyeToggleButton()
                    ],
                  )
              ),
            body: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: postData.length,
                itemBuilder: (context, index) {
                  final post = postData[index] as Map<String, dynamic>;
                  var pair = randomColor();
                  if (index == postData.length-1) {
                    return EndWidget();
                  } else if (index != 0 && index % 5 == 0) {
                    return QuizWidget(words: wordList);
                  } else {
                    return PostWidget(
                        post: post,
                        backgroundColor: pair.backgroundColor,
                        textColor: pair.textColor
                    );
                  }
                }
            )
          );
        }
        else {
          return const Center(child: Text('No posts found.'));
        }
      },
    );
  }
}


class EyeToggleButton extends StatefulWidget {
  const EyeToggleButton({super.key});

  @override
  State<EyeToggleButton> createState() => _EyeToggleButtonState();
}

class _EyeToggleButtonState extends State<EyeToggleButton> {
  bool _toggled = false;

  void _onTap() {
    setState(() {
      _toggled = !_toggled;
    });

    if (_toggled) {
      Future.delayed(const Duration(milliseconds: 300), () {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Icon(
          _toggled ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          key: ValueKey<bool>(_toggled),
          color: _toggled ? primaryOrange : Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}