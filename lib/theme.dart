import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF807ED5);
const Color primaryColorLight = Color(0xFFB3B2DF);
const Color primaryColorDark = Color(0xFF5C58C7);
Color? secondaryColor = Colors.green[300];

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: "OpenSans",
      colorSchemeSeed: Colors.white,
      canvasColor: Colors.white,
      dividerColor: Colors.white,
      indicatorColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      unselectedWidgetColor: Colors.white,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white, // 배경색
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // 제목 색
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black87, // 내용 색
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
              return primaryColorLight;
            }
            return null;
          },
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

const Color boxGrayColor = Color(0xFFF5F5F7);
const Color dividerNormal = Color(0xFFC7C7C7);

const double defaultBorderRadius = 16.0;

final BoxDecoration primaryBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  color: primaryColor,
);

final BoxDecoration grayBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  color: Colors.white,
  border: Border.all(color: dividerNormal, width: 1),
);
