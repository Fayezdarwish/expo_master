import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class ExhibitorRequestFormScreen extends StatefulWidget {
  const ExhibitorRequestFormScreen({super.key});

  @override
  State<ExhibitorRequestFormScreen> createState() => _ExhibitorRequestFormScreenState();
}

class _ExhibitorRequestFormScreenState extends State<ExhibitorRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String companyName = '';
  String contactPerson = '';
  String email = '';
  String phone = '';
  bool isSubmitting = false;

  Map<String, dynamic>? department;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // جلب بيانات القسم الممررة من الشاشة السابقة
    department = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isSubmitting = true);

    final success = await VisitorApi.submitExhibitorRequest({
      'company_name': companyName,
      'contact_person': contactPerson,
      'email': email,
      'phone': phone,
      'department_id': department?['id'],
    });

    setState(() => isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب بنجاح')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل في إرسال الطلب')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلب مشاركة - ${department?['name'] ?? ''}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الشركة'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                onSaved: (value) => companyName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الشخص المسؤول'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                onSaved: (value) => contactPerson = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                onSaved: (value) => phone = value!,
              ),
              const SizedBox(height: 24),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: submitForm,
                child: const Text('إرسال الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
