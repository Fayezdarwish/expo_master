import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class CreateWingScreen extends StatefulWidget {
  const CreateWingScreen({super.key});
  @override State<CreateWingScreen> createState() => _CreateWingScreenState();
}

class _CreateWingScreenState extends State<CreateWingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitWing() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final token = await TokenStorage.getToken();
    final res = await ApiService.postWithToken(
        '/create-wing',
        {'name': _nameCtl.text},
        token!
    );
    setState(() => _isLoading = false);
    final msg = res?.statusCode == 201 ? 'تم إنشاء الجناح!' : 'فشل الإنشاء';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    if (res?.statusCode == 201) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء جناح')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(labelText: 'اسم الجناح'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitWing,
                child: const Text('إنشاء الجناح'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
