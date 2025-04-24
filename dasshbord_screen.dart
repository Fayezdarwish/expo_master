import 'package:flutter/material.dart';

class WelcomScreen extends StatelessWidget {
  const WelcomScreen({super.key});

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
              onPressed: () {
              },
              icon: const Icon(Icons.add_business),
              label: Text(
                'إنشاء معرض',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
              },
              icon: const Icon(Icons.manage_accounts),
              label: Text(
                'إدارة معرض',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
              },
              icon: const Icon(Icons.bar_chart),
              label: Text(
                'عرض التقارير',
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
