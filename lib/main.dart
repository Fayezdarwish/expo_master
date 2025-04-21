import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'config/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expo Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: LoginScreen(),
    );
  }
}
