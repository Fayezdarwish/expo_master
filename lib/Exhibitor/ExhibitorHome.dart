import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ExhibitorHomeScreen extends StatelessWidget {
  const ExhibitorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصفحة الرئيسية')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/exhibitor/add-product'),
              child: const Text('إضافة منتج'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/exhibitor/my-products'),
              child: const Text('منتجاتي'),
            ),
          ],
        ),
      ),
    );
  }
}
