import 'package:flutter/material.dart';
import 'dart:math';

Color getRandomColorBetween(Color start, Color end) {
  final random = Random();
  double t = random.nextDouble();
  return Color.lerp(start, end, t)!;
}

const Color primaryOrange = Color(0xFFFFB823);
const Color primaryLightOrange = Color(0xFFFFF1CA);
const Color primaryGreen = Color(0xFF708A58);
const Color primaryDarkGreen = Color(0xFF2D4F2B);

({Color backgroundColor, Color textColor}) randomColor() {
  final random = Random();
  double t = random.nextDouble();
  if (t > 0.5) {
    return (backgroundColor: getRandomColorBetween(primaryOrange, primaryLightOrange), textColor: Colors.black);
  } else {
    return (backgroundColor: getRandomColorBetween(primaryGreen, primaryDarkGreen), textColor: Colors.white);
  }
}

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: "Inter",
      colorSchemeSeed: Colors.white,
      canvasColor: Colors.white,
      dividerColor: Colors.white,
      indicatorColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      unselectedWidgetColor: Colors.white,
      dialogTheme: DialogTheme(
        backgroundColor: primaryLightOrange,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(Colors.white),
        checkColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return primaryLightOrange;
            }
            return null;
          },
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

const Color boxGrayColor = Color(0xFFF9F9F9);
const Color dividerNormal = Color(0xFFC7C7C7);

const double defaultBorderRadius = 16.0;

final BoxDecoration primaryBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  color: primaryOrange,
);

final BoxDecoration grayBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  color: Colors.white,
  border: Border.all(color: dividerNormal, width: 1),
);
