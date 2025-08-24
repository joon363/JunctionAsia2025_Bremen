import '../theme.dart';
import 'package:flutter/material.dart';
import '../models/word.dart';
import 'base_post_widget.dart';
class QuizWidget extends BasePostWidget {
  final List<dynamic> words;
  const QuizWidget({
    super.key,
    required this.words
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends BasePostWidgetState<QuizWidget> {

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
    return Container(
      decoration: BoxDecoration(
        color: primaryGreen
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: pageCount,
        itemBuilder: (context, index) {
          Word word = widget.words[index ~/ 2];
          switch (index) {
            case 0:
            case 2:
            case 4:
              return QuizPage(
                quizTitle: word.word,
              );
            case 1:
            case 3:
            case 5:
              return AnswerPage(
                answerTitle: word.wordMeaning,
                isEnd: index == 5
              );
            default:
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  bool get isOverlay => false;

  @override
  int get pageCount => 6;
}
abstract class BaseQuizPage extends StatelessWidget {
  const BaseQuizPage({super.key});

  String get imagePath;
  String get title;
  String get subtitle;
  double get titleFontSize => 30;
  double get subtitleFontSize => 20;
  Color get titleColor => primaryLightOrange;
  Color get subtitleColor => primaryLightOrange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            child: SizedBox(
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Nanum",
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                    color: subtitleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class QuizPage extends BaseQuizPage {
  final String quizTitle;
  const QuizPage({super.key, required this.quizTitle});

  @override
  String get imagePath => "assets/images/ybm_cat_problem.png";

  @override
  String get title => quizTitle;

  @override
  String get subtitle => "넘겨서 뜻 보기 →";

  @override
  double get titleFontSize => 45; // QuizPage는 글자 크기 다름
}

class AnswerPage extends BaseQuizPage {
  final String answerTitle;
  final bool isEnd;

  const AnswerPage({super.key, required this.answerTitle, required this.isEnd});

  @override
  String get imagePath => "assets/images/ybm_cat_answer.png";

  @override
  String get title => answerTitle;

  @override
  String get subtitle => isEnd ? "수고하셨습니다 👍" : "넘겨서 다음 단어 보기 →";

  @override
  double get titleFontSize => 30;
}

