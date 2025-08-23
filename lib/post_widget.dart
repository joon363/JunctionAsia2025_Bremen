import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// A widget representing a single post in the feed
class PostWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostWidget({super.key, required this.post});

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
          // 1. Post Header
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.post['subreddit'] ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.more_horiz),
              ],
            ),
          ),

          // 2. Post Content (Horizontally Scrollable Pages)
          SizedBox(
            // Use a fixed height based on screen width for a square aspect ratio
            height: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                // Return the correct page widget based on the index
                switch (index) {
                  case 0:
                    return _TitlePage(title: widget.post['title']);
                  case 1:
                    return _BodyPageWithTooltip(body: widget.post['body']);
                  case 2:
                    return _CommentsPage(comments: widget.post['comments']);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action buttons
                    Row(
                      children: const[
                        Icon(Icons.favorite_border, size: 28),
                        SizedBox(width: 16),
                        Icon(Icons.chat_bubble_outline, size: 28),
                        SizedBox(width: 16),
                        Icon(Icons.send_outlined, size: 28),
                      ],
                    ),
                    // Page indicator dots
                    Row(
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
                    // Bookmark icon
                    const Icon(Icons.bookmark_border, size: 28),
                  ],
                ),
                const SizedBox(height: 8),
                // Display the tag
                Text(
                  '#${(widget.post['tag'] as List).join(' #')}',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Widget for the first page, displaying the title
class _TitlePage extends StatelessWidget {
  final String title;
  const _TitlePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Colors.grey[200],
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}


class _BodyPageWithTooltip extends StatefulWidget {
  final String body;
  const _BodyPageWithTooltip({required this.body});

  @override
  State<_BodyPageWithTooltip> createState() => _BodyPageWithTooltipState();
}

class _BodyPageWithTooltipState extends State<_BodyPageWithTooltip> {
  Map<String, Map<String, dynamic>> wordDataAll = {};
  Map<String, dynamic> wordData = {};
  String? highlightedWord;
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;

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
    print(position.dx - 100);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: (position.dx - 100) < -42 ? -42 : (position.dx - 100), // 중앙 정렬
        top: position.dy - 60,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 60,
            width: 200,
            child: Center( // Center로 가운데 정렬
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 0, top: 4, bottom: 4),
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
                                  Text(word, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                  Text(wordData['word_meaning'] ?? ""),
                                  SizedBox(height: 8,),
                                  Text("예문", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(wordData['example']?['example_eng'] ?? ""),
                                  Text(wordData['example']?['example_kor'] ?? ""),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('닫기'),
                                ),
                              ],
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
        padding: const EdgeInsets.all(24.0),
        color: Colors.blueGrey[50],
        child: Center(
          child: Wrap(
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
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                        color: highlightedWord == word
                          ? Colors.yellow.withOpacity(0.5)
                          : Colors.transparent,
                        child: Text(word, style: TextStyle(fontSize: 18)),
                      ),
                    );
                  },
                );
              }).toList(),
          ),
        ),
      )
    );
  }
}

// Widget for the third page, displaying the comments
class _CommentsPage extends StatelessWidget {
  final List<dynamic> comments;
  const _CommentsPage({required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Colors.teal[50],
      child: ListView.separated(
        itemCount: comments.length,
        separatorBuilder: (context, index) => const Divider(height: 30),
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.comment, color: Colors.grey[700], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  comments[index],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
