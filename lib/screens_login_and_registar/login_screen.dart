import 'package:expo_master/screens_login_and_registar/register_screen.dart';
import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

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
      final userType = result['userType'];

      switch (userType) {
        case 4:
          Navigator.pushReplacementNamed(context, '/admin/welcome');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/section/manager');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/exhibitor/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/visitor/home');
          break;
        default:
          showMessage("نوع الحساب غير معروف");
      }
    } else {
      showMessage("فشل تسجيل الدخول");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
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
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text('نسيت كلمة المرور؟'),
            ),

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
