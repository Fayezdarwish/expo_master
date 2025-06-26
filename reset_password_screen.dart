import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void handleResetPassword(String email) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showMessage("يرجى إدخال كلمة مرور وتأكيدها");
      return;
    }

    setState(() => isLoading = true);

    final result = await VisitorApi.resetPassword(
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    setState(() => isLoading = false);

    if (result != null && result['message'] != null) {
      showMessage("تم تغيير كلمة المرور بنجاح");
      Navigator.popUntil(context, ModalRoute.withName('/login'));
    } else {
      showMessage("فشل في تغيير كلمة المرور");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text("إعادة تعيين كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("أدخل كلمة المرور الجديدة وأكدها"),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "كلمة المرور الجديدة",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "تأكيد كلمة المرور",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => handleResetPassword(email),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("إعادة التعيين"),
            ),
          ],
        ),
      ),
    );
  }
}
