import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';

class PostsViewModel extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setInitialPosts(List<Post> posts) {
    _posts = posts;
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Post>> loadPosts() async {
    _isLoading = true;
    final String jsonString =
    await rootBundle.loadString('assets/datas/kpop_posts.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Post.fromJson(e)).toList();
  }
}
