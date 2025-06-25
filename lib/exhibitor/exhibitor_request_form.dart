import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class ExhibitorRequestForm extends StatefulWidget {
  final Map<String, dynamic> department;

  const ExhibitorRequestForm({super.key, required this.department});

  @override
  State<ExhibitorRequestForm> createState() => _ExhibitorRequestFormState();
}

class _ExhibitorRequestFormState extends State<ExhibitorRequestForm> {
  final reasonCtrl = TextEditingController();
  bool isLoading = false;

  void submitRequest() async {
    setState(() => isLoading = true);
    final token = await TokenStorage.getToken();

    final success = await VisitorApi.submitExhibitorRequest({
      'departmentId': widget.department['id'],
      'reason': reasonCtrl.text,
    }, token!);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/exhibitor/status');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تقديم الطلب')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب العارض')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('القسم: ${widget.department['name']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: reasonCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'سبب المشاركة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : submitRequest,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('إرسال الطلب'),
            )
          ],
        ),
      ),
    );
  }
}
