import 'package:expo_master/visitor/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:expo_master/utils/token_storage.dart';

import '../api/visitor_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);

    final result = await VisitorApi.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result != null) {
      final token = result['token'];
      final name = result['name'];
      final userType = result['userType'];

      // ✅ حفظ التوكن
      await TokenStorage.saveToken(token);

      // ✅ رسالة ترحيب
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("مرحبًا $name"),
          backgroundColor: Colors.green,
        ),
      );

      // ✅ توجيه المستخدم حسب النوع
      if (userType == 4) {
        Navigator.pushNamed(context, '/manager-dashboard');
      } else {
        Navigator.pushNamed(context, '/visitor-home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل تسجيل الدخول"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expo Master")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 16),
            Text("تسجيل الدخول", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 32),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "كلمة المرور",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: handleLogin,
                icon: const Icon(Icons.login),
                label: const Text("تسجيل الدخول"),
              ),
            ),
            const SizedBox(height: 16),

            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("إنشاء حساب جديد"),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
