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
    if (departmentId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        departmentId = args;
      }
    }
  }

  void submit() {
    if (_formKey.currentState!.validate() && departmentId != null) {
      // إرسال البيانات للباك
      // نموذج إرسال البيانات:
      /*
      {
        "exhibitionName": exhibitionName,
        "departmentId": departmentId,
        "contactPhone": contactPhone,
        "notes": notes
      }
      */
      Navigator.pushNamed(context, '/exhibitor/payment');
    } else if (departmentId == null) {
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
                decoration: const InputDecoration(labelText: 'اسم المعرض'),
                onChanged: (value) => exhibitionName = value,
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال اسم المعرض' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => contactPhone = value,
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ملاحظات'),
                maxLines: 3,
                onChanged: (value) => notes = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: const Text('تثبيت الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
