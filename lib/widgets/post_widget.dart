import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reelstudy/theme.dart';
class PostWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final Color backgroundColor;
  final Color textColor;
  const PostWidget({super.key,
    required this.post,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<String> unknownWords = [];

  Future<void> _loadUnknownWords() async {
    final String jsonString =
      await rootBundle.loadString('assets/datas/voca_user.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<String> words = jsonList.map((item) => item['word'] as String).toList();
    unknownWords = words;
  }

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
    _loadUnknownWords();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int pageCount = 3;

    return Center(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child:
            Container(
              color: widget.backgroundColor,
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _TitlePage(
                        title: widget.post['title'],
                        textColor: widget.textColor
                      );
                    case 1:
                      return _BodyPageWithTooltip(
                        body: widget.post['body'],
                        subreddit: widget.post['subreddit'],
                        textColor: widget.textColor
                      );
                    case 2:
                      return _CommentsPage(
                        comments: widget.post['comments'],
                        subreddit: widget.post['subreddit'],
                        textColor: widget.textColor,
                        unknownWords: unknownWords,
                      );
                    default:
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pageCount, (index) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                          ? Colors.blue
                          : Colors.grey.shade400,
                      ),
                    );
                  }),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  _PostHeading(subreddit: widget.post['subreddit'], textColor: widget.textColor),
                  Divider(color: widget.textColor,),
                  SizedBox(height: 4,),
                ],
              ),)
          )
        ],
      ),
    );
  }
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

class _BodyPageWithTooltip extends StatefulWidget {
  final String body;
  final String subreddit;
  final Color textColor;
  const _BodyPageWithTooltip({required this.body, required this.subreddit, required this.textColor});

  @override
  State<_BodyPageWithTooltip> createState() => _BodyPageWithTooltipState();
}

class _BodyPageWithTooltipState extends State<_BodyPageWithTooltip> {
  Map<String, Map<String, dynamic>> wordDataAll = {};
  Map<String, dynamic> wordData = {};
  List<String> highlightedWords = [];
  List<String> words = [];
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  double x = 0;

  @override
  void initState() {
    super.initState();
    loadVoca();
    loadBodyAndHighlight();
  }

  Future<void> loadVoca() async {
    final String jsonString = await rootBundle.loadString('assets/datas/voca_all.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    Map<String, Map<String, dynamic>> wordMap = {
      for (var item in jsonData) item['word']: item
    };
    setState(() {
        wordDataAll = wordMap;
      });
  }

  Future<void> loadBodyAndHighlight() async {
    words = widget.body
      .split(RegExp(r'\s+'))
      .map((w) => w.trim())
      .where((w) => w.isNotEmpty)
      .toList();
    final unknownWords = await _loadUnknownWords();
    setState(() {
        highlightedWords = words.where((w) => unknownWords.contains(w)).toList();
      });
  }

  Future<List<String>> _loadUnknownWords() async {
    final String jsonString =
      await rootBundle.loadString('assets/datas/voca_user.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<String> words = jsonList.map((item) => item['word'] as String).toList();
    return words;
  }

  String shortenString(String? text) {
    if (text == null) return "";
    if (text.length <= 8) return text;
    return "${text.substring(0, 8)}..";
  }

  void showTooltip(BuildContext context, String word, Offset position) {
    hideTooltip();
    if (wordDataAll[word] == null) return;
    wordData = wordDataAll[word]!;
    x = (position.dx - 100);
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
                              shortenString(wordData['word_meaning'] ?? ""),
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
                                      Text(word, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 4,),
                                      Text(wordData['word_meaning'] ?? ""),
                                      SizedBox(height: 8,),
                                      Text("예문", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("• ${wordData['example']?['example_eng'] ?? ""}"),
                                      Text("  ${wordData['example']?['example_kor'] ?? ""}"),
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
                  _SmallTriangle(),
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

  @override
  Widget build(BuildContext context) {
    final words = widget.body
      .split(RegExp(r'\s+'))
      .map((w) => w.trim())
      .where((w) => w.isNotEmpty)
      .toList();
    final adaptedFontSize = words.length <= 75
      ? 20.0
      : (20 - (words.length - 75) * (0.05)).clamp(12.0, 20.0);
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
                builder: (wordContext) {
                  return GestureDetector(
                    onTap: () {
                      final RenderBox box = wordContext.findRenderObject() as RenderBox;
                      final position = box.localToGlobal(Offset(box.size.width / 2, 0));
                      showTooltip(wordContext, word, position);
                    },
                    onLongPress: () {
                      setState(() {
                          if (highlightedWords.contains(word)) {
                            highlightedWords.remove(word);
                          } else {
                            highlightedWords.add(word);
                          }
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

class _CommentsPage extends StatefulWidget {
  const _CommentsPage({
    required this.subreddit,
    required this.textColor,
    required this.comments,
    required this.unknownWords,
  });
  final List<dynamic> comments;
  final String subreddit;
  final Color textColor;
  final List<String> unknownWords;

  @override
  State<_CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<_CommentsPage> {

  Map<String, Map<String, dynamic>> wordDataAll = {};
  Map<String, dynamic> wordData = {};
  List<String> highlightedWords = [];
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  double x = 0;

  @override
  void initState() {
    super.initState();
    loadVoca();
    loadBodyAndHighlight();
  }

  Future<void> loadVoca() async {
    final String jsonString = await rootBundle.loadString('assets/datas/voca_all.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    Map<String, Map<String, dynamic>> wordMap = {
      for (var item in jsonData) item['word']: item
    };
    setState(() {
        wordDataAll = wordMap;
      });
  }

  Future<void> loadBodyAndHighlight() async {
    final List<String> words = widget.comments
      .cast<String>()
      .expand((comment) => comment
          .split(RegExp(r'\s+'))
          .map((w) => w.trim())
          .where((w) => w.isNotEmpty))
      .toList();
    setState(() {
        highlightedWords = words.where((w) => widget.unknownWords.contains(w)).toList();
      });
  }

  String shortenString(String? text) {
    if (text == null) return "";
    if (text.length <= 8) return text;
    return "${text.substring(0, 8)}..";
  }

  void showTooltip(BuildContext context, String word, Offset position) {
    hideTooltip();
    if (wordDataAll[word] == null) return;
    wordData = wordDataAll[word]!;
    x = (position.dx - 100);
    if (x < -42) x = -42;
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shortenString(wordData['word_meaning'] ?? ""),
                            style: TextStyle(fontSize: 18),
                          ),
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
                                      Text(word, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 4,),
                                      Text(wordData['word_meaning'] ?? ""),
                                      SizedBox(height: 8,),
                                      Text("예문", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("• ${wordData['example']?['example_eng'] ?? ""}"),
                                      Text("  ${wordData['example']?['example_kor'] ?? ""}"),
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
                  _SmallTriangle(),
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

  @override
  Widget build(BuildContext context) {
    final processedComments = widget.comments.map((comment) {
        return (comment as String)
          .split(RegExp(r'\s+'))
          .map((w) => w.trim())
          .where((w) => w.isNotEmpty)
          .toList();
      }).toList();
    final totalWords = processedComments.fold<int>(
        0, (prev, words) => prev + words.length);

    // 3️⃣ adaptive font size 계산 (총 단어 수 기준)
    final adaptedFontSize = totalWords <= 75
        ? 20.0
        : (20 - (totalWords - 75) * (0.5)).clamp(12.0, 20.0);
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
                                      if (highlightedWords.contains(word)) {
                                        highlightedWords.remove(word);
                                      } else {
                                        highlightedWords.add(word);
                                      }
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

class _PostHeading extends StatelessWidget {
  const _PostHeading({
    required this.subreddit,
    required this.textColor
  });

  final String subreddit;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/reddit_logo.png'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "r/$subreddit",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: "Nanum",
              color: textColor
            ),
          ),
        ),
      ],
    );
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

class _SmallTriangle extends StatelessWidget {
  const _SmallTriangle();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 10),
      painter: _TrianglePainter(),
    );
  }
}
