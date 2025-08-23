import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reelstudy/theme.dart';
// A widget representing a single post in the feed
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
  // Controller to manage the pages and listen for page changes
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    // Add a listener to the controller to update the current page index
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
  Widget build(BuildContext context) {
    // The number of pages is fixed at 3: Title, Body, Comments
    const int pageCount = 3;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 2. Post Content (Horizontally Scrollable Pages)
          Container(
            // Use a fixed height based on screen width for a square aspect ratio
            height: MediaQuery.of(context).size.width*(4/3),
            color: widget.backgroundColor,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                // Return the correct page widget based on the index
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
                      textColor: widget.textColor
                    );
                  default:
                  return const SizedBox.shrink();
                }
              },
            ),
          ),

          // 3. Action Buttons and Page Indicator
          Padding(
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
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum",
            color: textColor,
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
  String? highlightedWord;
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  double x = 0;

  @override
  void initState() {
    super.initState();
    loadVoca();
  }

  Future<void> loadVoca() async {
    final String jsonString = await rootBundle.loadString('assets/voca_all.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    Map<String, Map<String, dynamic>> wordMap = {
      for (var item in jsonData) item['word']: item
    };
    setState(() {
        wordDataAll = wordMap;
      });
  }

  void showTooltip(BuildContext context, String word, Offset position) {
    hideTooltip(); // 기존 툴팁 제거
    if (wordDataAll[word] == null) return;
    wordData = wordDataAll[word]!;
    x = (position.dx - 100);
    if (x < -42) x = -42;
    if (x > 220) x = 220;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: x, // 중앙 정렬
        top: position.dy - 60,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 60,
            width: 200,
            child: Center( // Center로 가운데 정렬
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
                            wordData['word_meaning'] ?? "",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            onPressed: () {
                              hideTooltip();
                              showDialog(context: context, builder: (dialogContext) =>
                                AlertDialog(
                                  //title:
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
                            padding: EdgeInsets.zero, // 내부 여백 제거
                            icon: Icon(Icons.more_horiz)
                          )
                        ],
                      ),
                    ),
                  ),
                  SmallTriangle(),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        hideTooltip();
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PostHeading(subreddit: widget.subreddit, textColor: widget.textColor),
            Divider(color: widget.textColor,),
            Wrap(
              spacing: 4,
              children: words.map((word) {
                  return Builder(
                    builder: (wordContext) {
                      return GestureDetector(
                        onTap: () {
                          final RenderBox box = wordContext.findRenderObject() as RenderBox;
                          //final position = box.localToGlobal(Offset(box.size.width/2, (-1)*box.size.height/2));
                          final position = box.localToGlobal(Offset(box.size.width / 2, 0));

                          showTooltip(wordContext, word, position);
                        },
                        onLongPress: () {
                          setState(() {
                              highlightedWord = highlightedWord == word ? null : word;
                            });
                        },
                        child: Container(
                          //padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                          color: highlightedWord == word
                            ? Colors.yellow.withOpacity(0.5)
                            : Colors.transparent,
                          child: Text(word, style: TextStyle(
                              fontSize: 18,
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
          ],
        )
      )
    );
  }
}

class _CommentsPage extends StatelessWidget {
  final List<dynamic> comments;
  final String subreddit;
  final Color textColor;
  const _CommentsPage({required this.comments, required this.subreddit, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          PostHeading(subreddit: subreddit, textColor: textColor),
          Divider(color: textColor,),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.comment, color: textColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            comments[index],
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: textColor
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ))
        ],
      )
    );
  }
}

class PostHeading extends StatelessWidget {
  const PostHeading({
    super.key,
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
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
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
        Icon(Icons.more_horiz, color: textColor,),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height); // 아래 중앙
    path.lineTo(0, 0);                        // 좌측 상단
    path.lineTo(size.width, 0);               // 우측 상단
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SmallTriangle extends StatelessWidget {
  const SmallTriangle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 10), // 작은 역삼각형 크기
      painter: TrianglePainter(),
    );
  }
}
