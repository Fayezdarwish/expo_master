import 'package:flutter/material.dart';
import '../User/DepartmentsScreen.dart';
import '../services/token_storage.dart';
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
int userType = 1; // 1 = زائر, 2 = عارض

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

print("📦 استجابة السيرفر: $result");

setState(() => isLoading = false);

if (result != null) {
// ✅ حفظ التوكن و نوع المستخدم بعد التسجيل
final token = result['token'];
final user = result['user'];

if (token != null && user != null) {
await TokenStorage.saveToken(token);
await TokenStorage.saveUserType(user['userType']);

showMessage("تم إنشاء الحساب بنجاح", isSuccess: true);
await Future.delayed(const Duration(seconds: 1));

if (userType == 2) {
Navigator.pushReplacementNamed(context, '/exhibitor/select-department');
} else if (userType == 1) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => DepartmentScreen()),
        (route) => false,
  );

}
} else {
showMessage("فشل في حفظ بيانات المستخدم");
}
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
final textTheme = Theme.of(context).textTheme;

return Scaffold(
appBar: AppBar(
title: const Text("Expo Master"),
centerTitle: true,
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
const Icon(Icons.person_add_alt_1_rounded, size: 64),
const SizedBox(height: 16),
Text("إنشاء حساب", style: textTheme.titleLarge),
const SizedBox(height: 32),

buildTextField(controller: nameController, label: 'الاسم الكامل', icon: Icons.person),
const SizedBox(height: 16),

buildTextField(controller: emailController, label: 'البريد الإلكتروني', icon: Icons.email),
const SizedBox(height: 16),

buildTextField(controller: passwordController, label: 'كلمة المرور', icon: Icons.lock, isPassword: true),
const SizedBox(height: 16),

buildTextField(controller: confirmPasswordController, label: 'تأكيد كلمة المرور', icon: Icons.lock_outline, isPassword: true),
const SizedBox(height: 24),

Align(
alignment: Alignment.centerRight,
child: Text("نوع الحساب", style: textTheme.bodyMedium),
),
const SizedBox(height: 8),

Row(
children: [
Expanded(child: buildAccountTypeCard(1, Icons.person, "زائر")),
const SizedBox(width: 8),
Expanded(child: buildAccountTypeCard(2, Icons.store, "عارض")),
],
),

const SizedBox(height: 32),
SizedBox(
width: double.infinity,
child: isLoading
? const Center(child: CircularProgressIndicator())
    : ElevatedButton.icon(
onPressed: handleRegister,
icon: const Icon(Icons.check_circle_outline),
label: const Text("تسجيل"),
),
),
],
),
),
),
);
}

Widget buildTextField({
required TextEditingController controller,
required String label,
required IconData icon,
bool isPassword = false,
}) {
return TextField(
controller: controller,
obscureText: isPassword,
decoration: InputDecoration(
labelText: label,
prefixIcon: Icon(icon),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
),
);
}

Widget buildAccountTypeCard(int type, IconData icon, String label) {
final isSelected = userType == type;

return GestureDetector(
onTap: () => setState(() => userType = type),
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: isSelected ? Theme.of(context).primaryColor : const Color(0xFF2C2C2E),
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: isSelected ? Colors.amber : Colors.grey.shade700,
width: 2,
),
),
child: Column(
children: [
Icon(icon, color: Colors.white),
const SizedBox(height: 8),
Text(label, style: const TextStyle(color: Colors.white)),
],
),
),
);
}
}