// add_wing_page.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

/// واجهة إضافة جناح جديد
class AddWingPage extends StatelessWidget {
  const AddWingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة جناح')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم الجناح'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final token = await TokenStorage.getToken();
                if (token != null) {
                  await ApiService.postWithToken('/wings', {
                    'name': nameController.text,
                  }, token);
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }
}
