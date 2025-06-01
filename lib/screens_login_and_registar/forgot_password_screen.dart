import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;

  void handleForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage("الرجاء إدخال البريد الإلكتروني");
      return;
    }

    setState(() => isLoading = true);

    final result = await VisitorApi.forgotPassword(email);

    setState(() => isLoading = false);

    if (result != null && result['email'] != null) {
      // ✅ ننتقل إلى شاشة إعادة التعيين ونرسل الإيميل
      Navigator.pushNamed(context, '/reset-password', arguments: result['email']);
    } else {
      showMessage("البريد غير موجود أو فشل في العملية");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نسيت كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("أدخل بريدك الإلكتروني وسنتحقق منه."),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleForgotPassword,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("متابعة"),
            )
          ],
        ),
      ),
    );
  }
}
