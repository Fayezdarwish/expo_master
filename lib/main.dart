import 'package:flutter/material.dart';
import 'Features/welcome/welcome_screen.dart';
import 'config/theme.dart';

void main() {
  runApp(const ExpoMasterApp());
}

class ExpoMasterApp extends StatelessWidget {
  const ExpoMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expo Master',
      theme: AppTheme.themeData,
      home: const WelcomeScreen(),
    );
  }
}
