// ✅ SubmitRequestScreen.dart
import 'package:flutter/material.dart';

class SubmitRequestScreen extends StatefulWidget {
  const SubmitRequestScreen({super.key});

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String exhibitionName = '';
  String contactPhone = '';
  String notes = '';
  int? departmentId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    departmentId ??= ModalRoute.of(context)?.settings.arguments as int?;
  }

  void submit() {
    if (_formKey.currentState!.validate() && departmentId != null) {
      Navigator.pushNamed(context, '/exhibitor/payment', arguments: {
        'exhibitionName': exhibitionName,
        'contactPhone': contactPhone,
        'notes': notes,
        'departmentId': departmentId,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار القسم')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقديم طلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم العارض'),
                onChanged: (value) => exhibitionName = value,
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال اسم المعرض' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => contactPhone = value,
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ملاحظات'),
                maxLines: 3,
                onChanged: (value) => notes = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: submit,
                icon: const Icon(Icons.check_circle),
                label: const Text('تثبيت الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
