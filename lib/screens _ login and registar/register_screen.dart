import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  int userType = 1; // 1 = زائر (افتراضي), 2 = عارض

  void handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage("الرجاء تعبئة جميع الحقول");
      return;
    }

    if (password != confirmPassword) {
      showMessage("كلمتا المرور غير متطابقتين");
      return;
    }

    setState(() => isLoading = true);

    final result = await VisitorApi.register(name, email, password, userType);

    setState(() => isLoading = false);

    if (result != null) {
      showMessage("تم إنشاء الحساب بنجاح", isSuccess: true);
      Navigator.pop(context);
    } else {
      showMessage("حدث خطأ أثناء إنشاء الحساب");
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
      appBar: AppBar(title: const Text("Expo Master")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_add_alt_1_rounded, size: 64),
              const SizedBox(height: 16),
              Text("إنشاء حساب", style: Theme.of(context).textTheme.titleLarge),
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
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerRight,
                child: Text("نوع الحساب", style: Theme.of(context).textTheme.bodyMedium),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => userType = 1),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: userType == 1 ? Theme.of(context).primaryColor : const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: userType == 1 ? Colors.amber : Colors.grey.shade700,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.person, color: Colors.white),
                            SizedBox(height: 8),
                            Text("زائر", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => userType = 2),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: userType == 2 ? Theme.of(context).primaryColor : const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: userType == 2 ? Colors.amber : Colors.grey.shade700,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.store, color: Colors.white),
                            SizedBox(height: 8),
                            Text("عارض", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: handleRegister,
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
