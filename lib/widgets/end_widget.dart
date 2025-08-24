
import '../theme.dart';
import 'package:flutter/material.dart';

class EndWidget extends StatefulWidget {
  const EndWidget({
    super.key
  });

  @override
  State<EndWidget> createState() => _EndWidgetState();
}

class _EndWidgetState extends State<EndWidget> {
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
    const int pageCount = 3;

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryLightOrange
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                return EndPage(index: index);
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
                          ? Colors.grey.shade800
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


class EndPage extends StatelessWidget {
  final int index;
  const EndPage({super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath;
    String title;
    String subtitle;
    switch (index){
      case 0:
        imagePath = "assets/images/ybm_cat_final_0.png";
        title = "오늘의 학습 완료!";
        subtitle = "오늘 학습할 컨텐츠를\n완벽하게 학습하셨습니다.";
      case 1:
        imagePath = "assets/images/ybm_cat_final_1.png";
        title = "다음 학습은?";
        subtitle = "단어장을 복습하거나\n통계 화면으로 이동해 보세요.";
      case 2:
        imagePath = "assets/images/ybm_cat_final_2.png";
        title = "새로운 컨텐츠";
        subtitle = "새로운 학습 컨텐츠는 매일 업데이트 됩니다.";
      default:
      imagePath = "assets/images/ybm_cat_problem.png";
      title = "Something went wrong";
      subtitle = "";
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        Expanded(child: SizedBox(
            child: Image.asset(imagePath, fit: BoxFit.cover,),
          ),),
        Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
        Expanded(child: Container()),
      ],
    );
  }
}

class AnswerPage extends StatelessWidget {
  final String title;
  final bool isEnd;
  const AnswerPage({super.key,
    required this.title,
    required this.isEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Expanded(child: SizedBox(
              child: Image.asset("assets/images/ybm_cat_answer.png", fit: BoxFit.cover,),
            ),),
          Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                    color: primaryLightOrange,
                  ),
                ),
                Text(
                  isEnd ? "수고하셨습니다 👍" : "넘겨서 다음 단어 보기 →",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                    color: primaryLightOrange,
                  ),
                ),
              ],
            )),
          Expanded(child: Container()),

        ],
      ),);
  }
}
