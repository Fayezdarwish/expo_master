import 'package:flutter/material.dart';

class welcom_screen extends StatelessWidget {
  const welcom_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('wlcom to expo master'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('أنشاء معرض'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('أدارة معرض'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('عرض التقارير'),
            ),
          ],
        ),
      ),
    );
  }
}
