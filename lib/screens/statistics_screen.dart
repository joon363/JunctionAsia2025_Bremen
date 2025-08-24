import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../theme.dart';

final random = Random();
Color getRandomGrassColor() {
  double opacity = (random.nextInt(100) + 1) * 0.01;
  double opacity_3 = opacity*opacity*opacity;
  return primaryBlue.withAlpha((opacity_3 * 255).round());
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Statistics',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),
          ),
      ),
      body: SingleChildScrollView(
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
                  style: TextStyle(fontSize: 28, color: primaryBlue, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                Icon(Icons.circle, color: Colors.grey.shade500, size: 20,),
                Text("User Average", style: TextStyle(fontSize: 12)),
                Icon(Icons.circle, color: primaryBlue, size: 20),
                Text("Me", style: TextStyle(fontSize: 12)),
              ],
            ),
            Container(
              height: 150,
              padding: EdgeInsets.only(left:8,right:16),
              child: LineChartWidget(),
            ),
            const SizedBox(height: 8),
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
                      style: TextStyle(fontSize: 24, color: primaryBlue, fontWeight: FontWeight.w700),
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
                      style: TextStyle(fontSize: 24, color: primaryBlue, fontWeight: FontWeight.w700),
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
                  style: TextStyle(fontSize: 24, color: primaryBlue, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("", style: TextStyle(fontSize: 12),)] + (["May", "Jun", "July", "Aug"]).map((entry) {
                return Text(entry, style: TextStyle(fontSize: 12));
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
                    color: getRandomGrassColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  ui.Image? starImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final data = await rootBundle.load('assets/images/ybm_cat_face.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      starImage = frame.image;
    });
  }
  final List<String> customBottomTitles = [
    "", "8/3", "", "8/20", "", "8/17", "", "8/24"
  ];
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withAlpha((0.3 * 255).round()),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withAlpha((0.3 * 255).round()),
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
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < customBottomTitles.length) {
                  return Text(
                    customBottomTitles[index],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text(""); // 범위 밖은 빈 문자열
              },
              interval: 1,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false,),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 4,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3.1),
              FlSpot(1, 2.8),
              FlSpot(2, 2.5),
              FlSpot(3, 2.4),
              FlSpot(4, 2.3),
              FlSpot(5, 2.2),
              FlSpot(6, 2.2),
              FlSpot(7, 2.1),
            ],
            color: Colors.grey.shade500,
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
              FlSpot(7, 0.8),
            ],
            color: primaryBlue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // 마지막 점이면 → 이미지 dot
                if (index == barData.spots.length - 1) {
                  return FlDotImagePainter(
                    starImage!,
                    size: const Size(32, 32),);
                }
                // 나머지는 기본 동그라미
                return FlDotCirclePainter(
                  radius: 4,
                  color: primaryBlue,
                  strokeWidth: 0,
                  strokeColor: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlDotImagePainter extends FlDotPainter {
  final ui.Image image;
  final Size size;

  FlDotImagePainter(this.image, {this.size = const Size(24, 24)});

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    final rect = Rect.fromCenter(
      center: offsetInCanvas,
      width: size.width,
      height: size.height,
    );
    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.contain,
    );
  }

  @override
  Size getSize(FlSpot spot) => size;

  @override
  Color get mainColor => Colors.transparent;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;

  @override
  bool hitTest(
      FlSpot spot, Offset touched, Offset center, double extraThreshold) {
    final rect =
    Rect.fromCenter(center: center, width: size.width, height: size.height);
    return rect.inflate(extraThreshold).contains(touched);
  }

  @override
  List<Object?> get props => [image, size];
}