import 'package:flutter/material.dart';

class AppTheme {
  static final themeData = ThemeData(
    brightness: Brightness.dark, //  استخدام الثيم الداكن للتطبيق بالكامل

    primaryColor: const Color(0xFFF5C518), //  اللون الأساسي (الأصفر المستخدم في الأزرار والعناصر البارزة)

    scaffoldBackgroundColor: const Color(0xFF1C1C1E), //  لون خلفية الشاشة بالكامل

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1C1E), //  لون خلفية AppBar (مطابق لخلفية التطبيق)
      elevation: 0, //  إلغاء الظل لجعل AppBar مسطحة
      titleTextStyle: TextStyle(
        color: Color(0xFFF5C518), //  لون عنوان AppBar (نفس اللون الأساسي)
        fontSize: 20, // 🔠 حجم خط العنوان
        fontWeight: FontWeight.bold, // 🔤 جعل الخط عريض
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFF5C518), //  لون أيقونات AppBar مثل سهم الرجوع أو القائمة
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white, //  لون العناوين الرئيسية
        fontSize: 24, // حجم الخط الرئيسي
        fontWeight: FontWeight.bold, //  عريض
      ),
      bodyMedium: TextStyle(
        color: Colors.white70, //  لون النصوص الثانوية (رمادي فاتح)
        fontSize: 16, //  حجم مناسب لقراءة مريحة
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true, // تعبئة حقل الإدخال بلون الخلفية المحدد
      fillColor: Color(0xFF2C2C2E), //  لون خلفية الحقول
      labelStyle: TextStyle(color: Colors.white70), //  لون النص التوضيحي للحقول
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)), //  جعل الحواف دائرية
        borderSide: BorderSide.none, //  لا حدود ظاهرة للحقول
      ),
      prefixIconColor: Color(0xFFF5C518), //  لون الأيقونات داخل حقول الإدخال
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF5C518), //  لون خلفية الأزرار
        foregroundColor: Colors.black, //  لون النص داخل الزر
        padding: const EdgeInsets.symmetric(vertical: 14), //  مساحة داخلية رأسية للزر
        textStyle: const TextStyle(
          fontSize: 16, //  حجم الخط داخل الأزرار
          fontWeight: FontWeight.w600, // وزن الخط متوسط إلى عريض
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // جعل الزر بحواف دائرية
        ),
      ),
    ),
  );
}
