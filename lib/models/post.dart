import 'dart:ui';
import '../theme.dart';

class Post {
  final String subreddit;
  final String title;
  final String body;
  final List<String> comments;
  final String tag;
  final Color backgroundColor;
  final Color textColor;

  Post({
    required this.subreddit,
    required this.title,
    required this.body,
    required this.comments,
    required this.tag,
    required this.backgroundColor,
    required this.textColor,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final pair = randomColor(); // 한 번만 호출
    return Post(
      subreddit: json['subreddit'],
      title: json['title'],
      body: json['body'],
      comments: List<String>.from(json['comments'] ?? []),
      tag: json['tag'],
      backgroundColor: pair.backgroundColor, // 랜덤 배경
      textColor: pair.textColor,             // 랜덤 텍스트
    );
  }
}
