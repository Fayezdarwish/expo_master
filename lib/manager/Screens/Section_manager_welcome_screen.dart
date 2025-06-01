import 'package:flutter/material.dart';
import '../../../screens_login_and_registar/logout_helper.dart';
import '../../booth/create_booth_screen.dart';
import '../../booth/manage_booths_screen.dart';
import '../../applications/section_applications_screen.dart';
import 'create_booth_screen.dart';

class SectionManagerWelcomeScreen extends StatelessWidget {
  final String sectionName;

  const SectionManagerWelcomeScreen({
    super.key,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('قسم: $sectionName'),
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
                const Icon(Icons.domain, size: 80, color: Color(0xFFF5C518)),
                const SizedBox(height: 16),
                Text(
                  "لوحة تحكم مدير القسم",
                  style: textTheme.titleLarge?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // زر إنشاء جناح جديد
                _buildButton(
                  context: context,
                  icon: Icons.add_business,
                  label: "إنشاء جناح جديد",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateBoothScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // زر إدارة الأجنحة
                _buildButton(
                  context: context,
                  icon: Icons.grid_view,
                  label: "إدارة الأجنحة",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageBoothsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // زر طلبات العارضين
                _buildButton(
                  context: context,
                  icon: Icons.assignment,
                  label: "طلبات العارضين",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SectionApplicationsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تابع لبناء زر بنفس تنسيقات التطبيق
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
