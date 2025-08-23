import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'words_screen.dart';
import 'home_screen.dart';
import 'theme.dart';
import 'statistics_screen.dart';

// Main function to run the app
void main() {
  runApp(const MyApp());
}

// The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      home: const MainScreen(),
    );
  }
}

// =================================================================
// Main Screen with Bottom Navigation
// =================================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  // 각 탭에 해당하는 AppBar 제목 리스트
  static const List<String> _appBarTitles = [
    'Statistics',
    'Study',
    'Wordbook',
  ];

  void _onItemTapped(int index) {
    setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          // 선택된 인덱스에 따라 제목을 동적으로 변경
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(CupertinoIcons.person_circle),
              Text(_appBarTitles[_selectedIndex],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: primaryOrange
                ),
              ),
              Icon(CupertinoIcons.bell),
            ],
          )

        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // 스크롤 불가능
          onPageChanged: (index) {
            setState(() {
                _selectedIndex = index;
              });
          },
          // PageView에 WordListPage 추가
          children: const <Widget>[
            ProfileScreen(),
            HomeScreen(),
            WordListPage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26, width: 1.0)), // 라인효과
          ),
          child: BottomNavigationBar(
            backgroundColor: boxGrayColor,
            unselectedItemColor: Colors.black,
            selectedItemColor: primaryOrange,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              color: Colors.black, // 제목 색
            ),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chart_bar),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.pencil),
                label: 'Study',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book),
                label: 'WordBook',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        )
      )
    );
  }
}

