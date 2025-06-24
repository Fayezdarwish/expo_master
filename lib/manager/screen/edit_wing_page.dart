// edit_wing_page.dart
import 'package:flutter/material.dart';

/// واجهة تعديل الجناح
class EditWingPage extends StatelessWidget {
  const EditWingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: "اسم الجناح الحالي");

    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الجناح')),
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
                // تعديل الجناح عبر API
              },
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }
}
