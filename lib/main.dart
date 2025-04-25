import 'package:expo_master/screens%20_%20login%20and%20registar/login_screen.dart';
import 'package:expo_master/screens%20_%20login%20and%20registar/register_screen.dart';
import 'package:flutter/material.dart';
import 'Features/exibition_manager/add_exibition/presentation/add_exibition_screen.dart';
import 'config/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expo Master',
      theme: AppTheme.themeData,
      locale: const Locale('ar'),
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),

      },
    );
  }
}
