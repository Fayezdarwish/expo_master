import 'package:flutter/material.dart';

class AppTheme {
  // ألوان متدرجة طبيعية بين الفاتح والداكن
  static const Color blueLight = Color(0xFF90CAF9);
  static const Color blueMedium = Color(0xFF42A5F5);
  static const Color blueDark = Color(0xFF1565C0);
  static const Color grayLight = Color(0xFFF5F7FA);
  static const Color grayMedium = Color(0xFFB0BEC5);
  static const Color grayDark = Color(0xFF37474F);
  static const Color accentYellow = Color(0xFFF9A825);

  static final themeData = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: grayLight,
    fontFamily: 'OpenSans',

    colorScheme: ColorScheme.light(
      primary: blueMedium,
      primaryContainer: blueDark,
      secondary: accentYellow,
      surface: Colors.white,
      background: grayLight,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: grayDark,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 8,
      shadowColor: blueDark.withOpacity(0.3),
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: blueDark,
        letterSpacing: 1.3,
        shadows: [
          Shadow(
            color: blueDark.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      iconTheme: IconThemeData(color: blueMedium, size: 28),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: grayDark,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
        shadows: [
          Shadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      bodyMedium: TextStyle(
        color: grayMedium,
        fontSize: 18,
        height: 1.5,
        letterSpacing: 0.3,
      ),
      labelMedium: TextStyle(color: grayMedium.withOpacity(0.7), fontSize: 14),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: grayMedium, fontWeight: FontWeight.w600),
      hintStyle: TextStyle(color: grayMedium.withOpacity(0.6), fontStyle: FontStyle.italic),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: grayMedium.withOpacity(0.4), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: blueMedium, width: 3),
      ),
      prefixIconColor: blueMedium,
      suffixIconColor: grayMedium,
      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 18, horizontal: 36),
        ),

        // تدرج متحرك عند التفاعل باستخدام Decoration داخل زر مخصص
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return blueDark;
          } else if (states.contains(MaterialState.hovered)) {
            return blueMedium.withOpacity(0.85);
          } else if (states.contains(MaterialState.focused)) {
            return blueMedium.withOpacity(0.9);
          }
          return blueMedium;
        }),

        foregroundColor: MaterialStateProperty.all(Colors.white),

        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
        )),

        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),

        elevation: MaterialStateProperty.resolveWith<double>((states) {
          if (states.contains(MaterialState.pressed)) return 14;
          if (states.contains(MaterialState.hovered)) return 10;
          if (states.contains(MaterialState.focused)) return 12;
          return 8;
        }),

        shadowColor: MaterialStateProperty.all(blueDark.withOpacity(0.5)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: blueMedium,
      elevation: 16,
      hoverElevation: 20,
      splashColor: blueDark.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    ),

    splashColor: blueMedium.withOpacity(0.3),
    highlightColor: blueDark.withOpacity(0.15),

    iconTheme: IconThemeData(color: blueMedium, size: 28),
  );
}
