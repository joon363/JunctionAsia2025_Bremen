import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/end_widget.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../viewmodels/posts_view_model.dart';
import '../viewmodels/words_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsVM = context.watch<PostsViewModel>();
    final posts = postsVM.posts;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: SizedBox()), // 왼쪽 빈 공간
            const Expanded(
              child: Center(
                child: Text(
                  'Feed',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: EyeToggleButton(),
              ),
            ),
          ],
        ),
      ),
      body: posts.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: posts.length + 1, // ✅ 마지막 EndWidget 포함
          itemBuilder: (context, index) {
            final wordsVM = context.watch<WordsViewModel>();
            final userWords = wordsVM.userWords;
            if (index == posts.length) {
              return EndWidget();
            }

            final post = posts[index];

            if (index != 0 && index % 5 == 0 && userWords.isNotEmpty) {
              return QuizWidget(words: userWords);
            } else {
              return PostWidget(
                post: post,
                backgroundColor: post.backgroundColor,
                textColor: post.textColor,
              );
            }
          },
        ),
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
