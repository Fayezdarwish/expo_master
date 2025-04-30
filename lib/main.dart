import 'package:expo_master/screens_login_and_registar/login_screen.dart';
import 'package:flutter/material.dart';
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
      home: const LoginScreen(),
    );
  }
}
