import '../theme.dart';
import 'package:flutter/material.dart';
import 'base_post_widget.dart';

class EndWidget extends BasePostWidget {
  const EndWidget({super.key});

  @override
  State<EndWidget> createState() => _EndWidgetState();
}

class _EndWidgetState extends BasePostWidgetState<EndWidget> {
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
        color: primaryLightOrange
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: pageCount,
        itemBuilder: (context, index) {
          return EndPage(index: index);
        },
      ),
    );
  }

  @override
  bool get isOverlay => false;

  @override
  int get pageCount => 3;
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
