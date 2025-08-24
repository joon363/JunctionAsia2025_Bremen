import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../viewmodels/posts_view_model.dart';
import '../viewmodels/words_view_model.dart';
import '../models/post.dart';
import '../models/word.dart';
import '../widgets/line_chart_widget.dart';


final random = Random();
Color getRandomGrassColor() {
  double opacity = (random.nextInt(100) + 1) * 0.01;
  double opacity_3 = opacity * opacity * opacity;
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
          spacing:2,
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
            const SizedBox(height: 12),
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
              padding: EdgeInsets.only(left: 8, right: 16),
              child: LineChartWidget(),
            ),
            const SizedBox(height: 12),
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
            Divider(),
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
            Divider(),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("", style: TextStyle(fontSize: 12),)] + (["May", "Jun", "July", "Aug"]).map((entry) {
                    return Text(entry, style: TextStyle(fontSize: 12));
                  }
                ).toList() + [Text("")],
            ),
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
