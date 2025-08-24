import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reelstudy/theme.dart';
import 'base_post_widget.dart';
import '../models/post.dart';
import '../models/word.dart';
import '../viewmodels/posts_view_model.dart';
import '../viewmodels/words_view_model.dart';

class PostWidget extends BasePostWidget {
  final Color backgroundColor;
  final Color textColor;
  final Post post;
  const PostWidget({
    super.key,
    required this.post,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends BasePostWidgetState<PostWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
        if (_pageController.page?.round() != _currentPage) {
          setState(() {
              _currentPage = _pageController.page!.round();
            });
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget buildMainContent(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        color: widget.backgroundColor,
        child: PageView.builder(
          controller: _pageController,
          itemCount: pageCount,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _TitlePage(
                    title: widget.post.title,
                    textColor: widget.textColor
                );
              case 1:
                return _BodyPage(
                    key: ValueKey(widget.post.title),
                    body: widget.post.body,
                    subreddit: widget.post.subreddit,
                    textColor: widget.textColor
                );
              case 2:
                return _CommentsPage(
                  comments: widget.post.comments,
                  subreddit: widget.post.subreddit,
                  textColor: widget.textColor,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  bool get isOverlay => true;

  @override
  int get pageCount => 3;
}

class _TitlePage extends StatelessWidget {
  final String title;
  final Color textColor;
  const _TitlePage({
    required this.title,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: -1,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

abstract class BasePage extends StatefulWidget {
  final String subreddit;
  final Color textColor;

  const BasePage({
    required this.subreddit,
    required this.textColor,
    super.key,
  });
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;

  String shortenString(String? text) {
    if (text == null) return "";
    if (text.length <= 8) return text;
    return "${text.substring(0, 8)}..";
  }

  void showTooltip(BuildContext context, String wordName, Offset position) {
    final postsVM = Provider.of<PostsViewModel>(context, listen: false);
    final wordsVM = Provider.of<WordsViewModel>(context, listen: false);
    final posts = postsVM.posts;
    final userWords = wordsVM.userWords;
    final allWords = wordsVM.allWords;
    Word? word = allWords.cast<Word?>().firstWhere(
      (w) => w!.word == wordName,
      orElse: () => null,
    );
    if (word == null) return;

    hideTooltip();
    var x = (position.dx - 100);
    if (x < -20) x = -20;
    if (x > 220) x = 220;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: x,
        top: position.dy - 60,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 60,
            width: 200,
            child: Center(
              child: Column(
                children: [
                  IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Flexible(child: Text(
                              shortenString(word.wordMeaning ?? ""),
                              style: TextStyle(fontSize: 18),
                            ),),
                          IconButton(
                            onPressed: () {
                              hideTooltip();
                              showDialog(context: context, builder: (dialogContext) =>
                                AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4,
                                    children: [
                                      Text(word.word, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 4,),
                                      Text(word.wordMeaning ?? ""),
                                      SizedBox(height: 8,),
                                      Text("예문", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("  ${word.exampleEng}"),
                                      Text("• ${word.exampleKor}"),
                                    ],
                                  ),
                                  actions: [
                                    Column(
                                      children: [
                                        Divider(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text('OK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    )
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_horiz)
                          )
                        ],
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(20, 10),
                    painter: _TrianglePainter(),
                  )
                ],
              )
            ),
          )
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 3), hideTooltip);
  }

  void hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _hideTimer?.cancel();
    _hideTimer = null;
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class _BodyPage extends BasePage {
  final String body;

  const _BodyPage({
    required this.body,
    required super.subreddit,
    required super.textColor,
    super.key,
  });

  @override
  State<_BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends BasePageState<_BodyPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsVM = context.watch<PostsViewModel>();
    final wordsVM = context.watch<WordsViewModel>();
    final posts = postsVM.posts;
    final userWords = wordsVM.userWords;
    final allWords = wordsVM.allWords;

    final words = widget.body
      .split(RegExp(r'\s+'))
      .map((w) => w.trim())
      .where((w) => w.isNotEmpty)
      .toList();

    final adaptedFontSize = words.length <= 75
      ? 20.0
      : (20 - (words.length - 75) * (0.05)).clamp(12.0, 20.0);

    final highlightedWords = words
      .where((w) => userWords.any((uw) => uw.word == w))
      .toList();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        hideTooltip();
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 4,
          children: words.map((word) {
              return Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final position = box.localToGlobal(Offset(box.size.width / 2, 0));
                      showTooltip(context, word, position);
                    },
                    onLongPress: () {
                      setState(() {
                        wordsVM.toggleUserWord(word);
                        });
                    },
                    child: Container(
                      color: highlightedWords.contains(word)
                        ? widget.textColor == Colors.black ? primaryGreen.withAlpha((0.5 * 255).round()) : Colors.yellow.withAlpha((0.5 * 255).round())
                        : Colors.transparent,
                      child: Text(word, style: TextStyle(
                          fontSize: adaptedFontSize,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nanum",
                          color: widget.textColor
                        )),
                    ),
                  );
                },
              );
            }).toList(),
        ),
      )
    );
  }
}

class _CommentsPage extends BasePage {
  final List<dynamic> comments;

  const _CommentsPage({
    required this.comments,
    required super.subreddit,
    required super.textColor,
    super.key,
  });

  @override
  State<_CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends BasePageState<_CommentsPage> {

  @override
  Widget build(BuildContext context) {
    final postsVM = context.watch<PostsViewModel>();
    final wordsVM = context.watch<WordsViewModel>();
    final posts = postsVM.posts;
    final userWords = wordsVM.userWords;

    final processedComments = widget.comments.map((comment) {
        return (comment as String)
          .split(RegExp(r'\s+'))
          .map((w) => w.trim())
          .where((w) => w.isNotEmpty)
          .toList();
      }).toList();

    final words = processedComments.expand((e) => e).toList();

    final adaptedFontSize = words.length <= 75
      ? 20.0
      : (20 - (words.length - 75) * (0.5)).clamp(12.0, 20.0);

    final highlightedWords = words
      .where((w) => userWords.any((uw) => uw.word == w))
      .toList();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        hideTooltip();
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.comment, color: widget.textColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Wrap(
                      spacing: 4,
                      children: processedComments[index].map((word) {
                          return Builder(
                            builder: (wordContext) {
                              return GestureDetector(
                                onTap: () {
                                  final RenderBox box = wordContext.findRenderObject() as RenderBox;
                                  final position = box.localToGlobal(Offset(box.size.width / 2, 0));

                                  showTooltip(wordContext, word, position);
                                },
                                onLongPress: () {
                                  setState(() {
                                    wordsVM.toggleUserWord(word);
                                  });
                                },
                                child: Container(
                                  color: highlightedWords.contains(word)
                                    ? widget.textColor == Colors.black ? primaryGreen.withAlpha((0.5 * 255).round()) : Colors.yellow.withAlpha((0.5 * 255).round())
                                    : Colors.transparent,
                                  child: Text(word, style: TextStyle(
                                      fontSize: adaptedFontSize,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nanum",
                                      color: widget.textColor
                                    )),
                                ),
                              );
                            },
                          );
                        }).toList(),
                    ),)
                ],
              ),
            );
          },
        ),
      )
    );
  }
}