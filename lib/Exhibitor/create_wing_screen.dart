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
      // هنا استدعاء API لإنشاء الجناح (لو متوفر)
      Navigator.pushReplacementNamed(context, '/exhibitor/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء جناح')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الجناح'),
                onChanged: (value) => wingName = value,
                validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم الجناح' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: const Text('موافق'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
