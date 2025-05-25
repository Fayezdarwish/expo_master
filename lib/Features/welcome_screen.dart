import 'package:flutter/material.dart';
import '../screens_login_and_registar/logout_helper.dart';
import 'sinup_screen_for_manger_section.dart';
import 'create_department_screen.dart';

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Color(0xFFF5C518)),
                const SizedBox(height: 16),
                Text(
                  "أهلاً بك في لوحة تحكم مدير المعرض",
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                _buildButton(
                  context: context,
                  icon: Icons.add_business,
                  label: "إنشاء قسم جديد",
                  onPressed: () async {
                    final managerId = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpManagerScreen()),
                    );
                    if (managerId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateDepartmentScreen(managerId: managerId),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                _buildButton(
                  context: context,
                  icon: Icons.manage_accounts,
                  label: "إدارة المعرض",
                  onPressed: () {
                  },
                ),
                const SizedBox(height: 16),

                _buildButton(
                  context: context,
                  icon: Icons.bar_chart,
                  label: "عرض التقارير",
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5C518),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
