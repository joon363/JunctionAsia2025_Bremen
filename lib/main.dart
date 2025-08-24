import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/posts_view_model.dart';
import 'viewmodels/words_view_model.dart';
import 'screens/words_screen.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final postsVM = PostsViewModel();
  final wordsVM = WordsViewModel();

  final posts = await postsVM.loadPosts();
  await wordsVM.loadAllWordsAndUserWords();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostsViewModel()..setInitialPosts(posts),
        ),
        ChangeNotifierProvider(
          create: (_) => wordsVM,
        ),
      ],
      child: const MyApp(),
    ),
  );
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const[
      ProfileScreen(),
      HomeScreen(),
      WordListPage(),
    ];
    return SafeArea(
      top: false,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: pages[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26, width: 0.2)),
          ),
          child: BottomNavigationBar(
            backgroundColor: boxGrayColor,
            unselectedItemColor: Colors.black,
            selectedItemColor: primaryBlue,
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
                icon: Icon(CupertinoIcons.chart_bar_fill),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.doc_plaintext),
                label: 'Study',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book_fill),
                label: 'WordBook',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                  _selectedIndex = index;
                });
            },
          ),
        )
      )
    );
  }
}
