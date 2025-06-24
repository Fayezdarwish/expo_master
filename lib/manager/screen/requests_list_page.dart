// requests_list_page.dart
import 'package:flutter/material.dart';
import 'RequestDetailsPage.dart';

/// واجهة عرض الطلبات
class RequestsListPage extends StatelessWidget {
  const RequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات')),
      body: ListView.builder(
        itemCount: 5, // مؤقتاً
        itemBuilder: (context, index) => ListTile(
          title: Text('طلب ${index + 1}'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RequestDetailsPage()),
          ),
        ),
      ),
    );
  }
}
