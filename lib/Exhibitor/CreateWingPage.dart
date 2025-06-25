import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class CreateWingPage extends StatefulWidget {
  @override
  _CreateWingPageState createState() => _CreateWingPageState();
}

class _CreateWingPageState extends State<CreateWingPage> {
  final _formKey = GlobalKey<FormState>();
  String wingName = '';
  String description = '';
  bool isLoading = false;

  Future<void> submitWing() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لم يتم العثور على التوكن')));
      return;
    }

    final wingData = {
      'name': wingName,
      'description': description,
    };

    final result = await VisitorApi.createWing(wingData, token);
    setState(() {
      isLoading = false;
    });

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الجناح بنجاح')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل إنشاء الجناح')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء جناح جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الجناح'),
                validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال اسم الجناح' : null,
                onSaved: (value) => wingName = value!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'الوصف'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال وصف' : null,
                onSaved: (value) => description = value!.trim(),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: submitWing,
                child: const Text('إنشاء'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
