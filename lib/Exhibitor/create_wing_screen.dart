import 'package:flutter/material.dart';

class CreateWingScreen extends StatefulWidget {
  const CreateWingScreen({super.key});

  @override
  State<CreateWingScreen> createState() => _CreateWingScreenState();
}

class _CreateWingScreenState extends State<CreateWingScreen> {
  final _formKey = GlobalKey<FormState>();
  String wingName = '';

  void submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الجناح'),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pushReplacementNamed(context, '/exhibitor/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء جناح')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('يرجى إدخال اسم الجناح الخاص بك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الجناح', border: OutlineInputBorder()),
                onChanged: (value) => wingName = value,
                validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم الجناح' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('موافق'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
