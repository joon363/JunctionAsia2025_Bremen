import 'theme.dart';
import 'package:flutter/material.dart';

class QuizWidget extends StatefulWidget {
  final List<dynamic> words;
  const QuizWidget({
    super.key,
    required this.words
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
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
  Widget build(BuildContext context) {
    const int pageCount = 6;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.width * (4 / 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryOrange,
                  primaryLightOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                final word = widget.words[index ~/ 2] as Map<String, dynamic>;
                switch (index) {
                  case 0:
                  case 2:
                  case 4:
                    return QuizPage(
                      title: word['word'],
                      textColor: Colors.black
                    );
                  case 1:
                  case 3:
                  case 5:
                    return QuizPage(
                      title: word['word_meaning'],
                      textColor: Colors.black
                    );
                  default:
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
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


class QuizPage extends StatelessWidget {
  final String title;
  final Color textColor;
  const QuizPage({super.key, 
    required this.title,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "── Review Session ──",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Nanum",
                color: textColor,
              ),
            ),)
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: "Nanum",
              color: textColor,
            ),
          ),
        ),
      ]
    );
  }
}
