import 'package:flutter/material.dart';
import '../../screens_login_and_registar/logout_helper.dart';
import '../auth/sinup_screen_for_manger_section.dart';
import '../department/create_department_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مرحبًا بك في Expo Master'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () => LogoutHelper.logoutUser(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                // ➕ افتح شاشة تسجيل مدير القسم أولاً
                final managerId = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpManagerScreen()),
                );

                // ✅ إذا تم الإرجاع بنجاح انتقل لإنشاء القسم
                if (managerId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateDepartmentScreen(managerId: managerId),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add_business),
              label: Text('إنشاء قسم جديد', style: textTheme.bodyMedium),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                // 🛠 توجيه لواجهة إدارة المعرض لاحقًا
              },
              icon: const Icon(Icons.manage_accounts),
              label: Text('إدارة المعرض', style: textTheme.bodyMedium),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                // 📊 توجيه لواجهة عرض التقارير لاحقًا
              },
              icon: const Icon(Icons.bar_chart),
              label: Text('عرض التقارير', style: textTheme.bodyMedium),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
