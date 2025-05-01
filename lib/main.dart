import 'package:flutter/material.dart';
import 'package:expo_master/config/theme.dart';
import 'package:expo_master/screens_login_and_registar/login_screen.dart';
import 'package:expo_master/screens_login_and_registar/register_screen.dart';
import 'Features/welcome/welcome_screen.dart';

void main() {
  runApp(const ExpoMasterApp());
}

class ExpoMasterApp extends StatelessWidget {
  const ExpoMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expo Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignUpScreen(),
        '/admin/welcome': (context) => const WelcomeScreen(),

      },
    );
  }
}
