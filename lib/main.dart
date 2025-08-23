import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'words_screen.dart';
import 'home_screen.dart';
import 'theme.dart';
final random = Random();



Color getRandomBlue() {
  // 0.2, 0.4, 0.6, 0.8, 1.0 중 랜덤 선택
  double opacity = (random.nextInt(5) + 1) * 0.2;
  return Colors.blue.withOpacity(opacity);
}

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
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // 각 탭에 해당하는 AppBar 제목 리스트
  static const List<String> _appBarTitles = [
    'ReelStudy',
    '나의 단어장',
    'Profile',
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
    return Scaffold(
      appBar: AppBar(
        // 선택된 인덱스에 따라 제목을 동적으로 변경
        title: Text(_appBarTitles[_selectedIndex]),
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
          HomeScreen(),
          WordListPage(), // 세 번째 탭으로 단어장 페이지 추가
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: '단어장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}



// The home screen widget that displays the feed

// NEW: The Profile Screen widget based on the wireframe
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // Graph Section
          const Text(
            '문장당 모르는 단어 수',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          // CHANGE: Replaced placeholder Container with a real chart widget
          SizedBox(
            height: 150,
            child: LineChartWidget(),
          ),
          const SizedBox(height: 24),

          // Stats Numbers Section
          _buildStatRow('학습 단어 수', '187개', '(상위 10%)'),
          const SizedBox(height: 12),
          _buildStatRow('읽은 포스트 수', '213개', '(상위 15%)'),
          const Divider(height: 48),

          // Study History Section
          const Text(
            '학습 기록',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 30,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: 200, // Example count
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: getRandomBlue(), // Example coloring
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
          const Divider(height: 48),

          // Final Summary Text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '토익 RC 350점의 수준이에요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for building a stat row
  Widget _buildStatRow(String title, String value, String percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(percentage, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

// NEW: The chart widget for the profile screen
class StatsChart extends StatelessWidget {
  const StatsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: leftTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey, width: 1),
            bottom: BorderSide(color: Colors.grey, width: 1),
            top: BorderSide(color: Colors.transparent),
            right: BorderSide(color: Colors.transparent),
          ),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          // User's progress line
          LineChartBarData(
            spots: const[
              FlSpot(0, 4.5), FlSpot(1, 4.2), FlSpot(2.5, 4), FlSpot(4, 3.5), FlSpot(5.5, 3.2),
            ],
            isCurved: true,
            color: Colors.purple,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Average line
          LineChartBarData(
            spots: const[
              FlSpot(0, 3), FlSpot(1.5, 2.8), FlSpot(3, 2.5), FlSpot(4.5, 2.2), FlSpot(6, 2),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  // Helper for bottom titles
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value.toInt() == 5) {
      text = const Text('t', style: style);
    } else {
      text = const Text('', style: style);
    }
    // FIX: The SideTitleWidget API has changed. We can simply return the Text widget.
    return text;
  }

  // Helper for left titles
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '평균';
        break;
      case 3:
        text = '나';
        break;
      case 4:
        text = '저';
        break;
      default:
      return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}


class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          //horizontalInterval: 10,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false, interval: 1),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // 우측 제거
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // 상단 제거
          ),
        ),

        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        //maxY: 40,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 5),
              FlSpot(1, 2.2),
              FlSpot(2, 2.0),
              FlSpot(3, 1.7),
              FlSpot(4, 1.2),
              FlSpot(5, 0.9),
              FlSpot(6, 0.8),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.purple.withOpacity(0.1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
