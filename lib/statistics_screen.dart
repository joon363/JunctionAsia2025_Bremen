import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'theme.dart';

final random = Random();
Color getRandomBlue() {
  double opacity = (random.nextInt(5) + 1) * 0.2;
  return Colors.blue.withOpacity(opacity);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '문장당 모르는 단어',
                style: TextStyle(fontSize: 16, letterSpacing: 0, fontWeight: FontWeight.w700),
              ),
              const Text(
                '0.8개',
                style: TextStyle(fontSize: 28, color: primaryOrange, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [
              Icon(Icons.circle, color: primaryGreen, size: 20,),
              Text("User Average", style: TextStyle(fontSize: 12)),
              Icon(Icons.circle, color: primaryOrange, size: 20),
              Text("Me", style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(
            height: 150,
            child: LineChartWidget(),
          ),
          const SizedBox(height: 8),
          //Divider(),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '학습 단어',
                style: TextStyle(fontSize: 16, letterSpacing: 0, fontWeight: FontWeight.w700),
              ),
              Column(
                children: [
                  const Text(
                    '187개',
                    style: TextStyle(fontSize: 24, color: primaryOrange, fontWeight: FontWeight.w700),
                  ), const Text(
                    '(상위 3.7%)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 2),
          Divider(),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '읽은 포스트',
                style: TextStyle(fontSize: 16, letterSpacing: 0, fontWeight: FontWeight.w700),
              ),
              Column(
                children: [
                  const Text(
                    '213개',
                    style: TextStyle(fontSize: 24, color: primaryOrange, fontWeight: FontWeight.w700),
                  ), const Text(
                    '(상위 5.3%)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 2),
          Divider(),
          const SizedBox(height: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '학습 기록',
                style: TextStyle(fontSize: 16, letterSpacing: 0, fontWeight: FontWeight.w700),
              ),
              const Text(
                'D+86',
                style: TextStyle(fontSize: 24, color: primaryOrange, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("")] + (["May", "Jun", "July", "Aug"]).map((entry) {
                  return Text(entry);
                }
              ).toList() + [Text("")],
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 20,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: 140,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: getRandomBlue(),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}

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
    return text;
  }

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
          drawVerticalLine: false,
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
        borderData: FlBorderData(
          show: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false, interval: 1),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 4,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3.1),
              FlSpot(1, 2.5),
              FlSpot(2, 2.5),
              FlSpot(3, 2.4),
              FlSpot(4, 2.3),
              FlSpot(5, 2.2),
              FlSpot(6, 2.2),
            ],
            color: primaryGreen,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, 3.6),
              FlSpot(1, 3.2),
              FlSpot(2, 2.0),
              FlSpot(3, 1.7),
              FlSpot(4, 1.2),
              FlSpot(5, 0.9),
              FlSpot(6, 0.8),
            ],
            color: primaryOrange,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
