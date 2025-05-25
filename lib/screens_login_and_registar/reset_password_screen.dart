import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final resetToken = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text("إعادة تعيين كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("أدخل كلمة المرور الجديدة"),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "كلمة المرور الجديدة",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newPassword = newPasswordController.text.trim();

                if (newPassword.isEmpty || resetToken == null) {
                  showMessage("يرجى إدخال كلمة مرور صالحة");
                  return;
                }

                setState(() => isLoading = true);
                final result = await VisitorApi.resetPassword(resetToken, newPassword);
                setState(() => isLoading = false);

                if (result) {
                  showMessage("تم تعيين كلمة المرور بنجاح");
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                } else {
                  showMessage("فشل إعادة التعيين");
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("إعادة التعيين"),
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
