import 'package:flutter/material.dart';

abstract class BasePostWidget extends StatefulWidget {
  const BasePostWidget({super.key});
}

abstract class BasePostWidgetState<T extends BasePostWidget> extends State<T> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool get isOverlay; // 하위 클래스에서 정의
  int get pageCount; // 하위 클래스에서 정의

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

  // 하위 클래스에서 구현할 메인 컨텐츠
  Widget buildMainContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Main Field
          buildMainContent(context),

          // Dots
          _BottomDots(pageCount: pageCount, currentPage: _currentPage),

          // Overlay
          if(isOverlay) _RedditOverlay(widget: widget),
        ],
      ),
    );
  }
}

class _RedditOverlay extends StatelessWidget {
  final widget;
  const _RedditOverlay({
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/reddit_logo.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "r/${widget.post.subreddit}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Nanum",
                      color: widget.textColor,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: widget.textColor),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _BottomDots extends StatelessWidget {
  const _BottomDots({
    required this.pageCount,
    required int currentPage,
  }) : _currentPage = currentPage;

  final int pageCount;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pageCount, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey.shade400,
                ),
              );
            }),
        ),
      ),
    );
  }
}
