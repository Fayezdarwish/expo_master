import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class EditWingPage extends StatefulWidget {
  final Map<String, dynamic> wing;
  const EditWingPage({super.key, required this.wing});

  @override
  State<EditWingPage> createState() => _EditWingPageState();
}

class _EditWingPageState extends State<EditWingPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.wing['name']);
  }

  Future<void> updateWing() async {
    await ApiService.putWithToken('/wings/${widget.wing['id']}', {
      'name': nameController.text,
    }, 'YOUR_TOKEN');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: updateWing,
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }
}
