import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';

class SignUpManagerScreen extends StatefulWidget {
  const SignUpManagerScreen({super.key});

  @override
  State<SignUpManagerScreen> createState() => _SignUpManagerScreenState();
}

class _SignUpManagerScreenState extends State<SignUpManagerScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void handleRegisterManager() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage("الرجاء تعبئة جميع الحقول");
      return;
    }

    if (password != confirmPassword) {
      showMessage("كلمتا المرور غير متطابقتين");
      return;
    }

    setState(() => isLoading = true);

    final int? managerId = await VisitorApi.registerManager(name, email, password);

    setState(() => isLoading = false);

    if (managerId != null) {
      showMessage("تم إنشاء الحساب بنجاح", isSuccess: true);
      Navigator.pop(context, managerId);
    } else {
      showMessage("فشل استلام المعرف من السيرفر");
    }
  }

  void showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل مدير قسم")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.badge, size: 64),
              const SizedBox(height: 16),
              Text("إنشاء حساب مدير قسم", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 32),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: handleRegisterManager,
                  icon: const Icon(Icons.check),
                  label: const Text("تسجيل"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
