import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class CreateWingScreen extends StatefulWidget {
  const CreateWingScreen({super.key});

  @override
  State<CreateWingScreen> createState() => _CreateWingScreenState();
}

class _CreateWingScreenState extends State<CreateWingScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  bool isLoading = false;

  void createWing() async {
    setState(() => isLoading = true);
    final token = await TokenStorage.getToken();

    final success = await VisitorApi.createWing({
      'name': nameCtrl.text,
      'description': descCtrl.text,
    }, token!);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/exhibitor/tasks');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل إنشاء الجناح')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء الجناح')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'اسم الجناح'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'وصف الجناح'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : createWing,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('إنشاء الجناح'),
            )
          ],
        ),
      ),
    );
  }
}
