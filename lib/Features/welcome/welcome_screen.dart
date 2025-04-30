import 'package:flutter/material.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                final managerId = await Navigator.push(
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
              icon: const Icon(Icons.add_business),
              label: const Text('إنشاء قسم جديد'),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('انتقال إلى إدارة المعرض')),
                );
              },
              icon: const Icon(Icons.manage_accounts),
              label: const Text('إدارة المعرض'),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('انتقال إلى عرض التقارير')),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text('عرض التقارير'),
            ),
          ],
        ),
      ),
    );
  }
}
