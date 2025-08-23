import 'package:flutter/cupertino.dart';

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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryGreen
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
                    );
                  case 1:
                  case 3:
                  case 5:
                    return AnswerPage(
                      title: word['word_meaning'],
                    );
                  default:
                  return const SizedBox.shrink();
                }
              },
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
          )
        ],
      ),
    );
  }
}


class QuizPage extends StatelessWidget {
  final String title;
  const QuizPage({super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(CupertinoIcons.question_square, size: 80, color: primaryLightOrange,),
        Text(
          title,
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum",
            color: primaryLightOrange,
          ),
        ),
        Text(
          "넘겨서 뜻 보기",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: "Nanum",
            color: primaryLightOrange,
          ),
        ),
      ],
    );
  }
}

class AnswerPage extends StatelessWidget {
  final String title;
  const AnswerPage({super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.exclamationmark_square_fill, size: 80, color: primaryLightOrange,),
          Text(
            title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "Nanum",
              color: primaryLightOrange,
            ),
          ),
          Text(
            "넘겨서 다음 퀴즈 보기",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: "Nanum",
              color: primaryLightOrange,
            ),
          ),
        ],
      ),);
  }
}
