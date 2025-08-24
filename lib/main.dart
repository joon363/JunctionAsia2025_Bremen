import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/words_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';
import 'screens/statistics_screen.dart';

void main() {
  runApp(const MyApp());
}

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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(CupertinoIcons.person_circle),
              Text(_appBarTitles[_selectedIndex],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                ),
              ),
              EyeToggleButton()
            ],
          )

        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
                _selectedIndex = index;
              });
          },
          children: const <Widget>[
            ProfileScreen(),
            HomeScreen(),
            WordListPage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26, width: 1.0)),
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
              color: Colors.black,
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

class EyeToggleButton extends StatefulWidget {
  const EyeToggleButton({super.key});

  @override
  State<EyeToggleButton> createState() => _EyeToggleButtonState();
}

class _EyeToggleButtonState extends State<EyeToggleButton> {
  bool _toggled = false;

  void _onTap() {
    setState(() {
        _toggled = !_toggled;
      });

    if (_toggled) {
      Future.delayed(const Duration(milliseconds: 300), () {
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Icon(
          _toggled ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          key: ValueKey<bool>(_toggled),
          color: _toggled ? primaryOrange : Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}
