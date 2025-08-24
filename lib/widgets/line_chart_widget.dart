import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import '../theme.dart';


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
                return const Text("");
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
                if (index == barData.spots.length - 1) {
                  return FlDotImagePainter(
                    starImage!,
                    size: const Size(32, 32),);
                }
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
