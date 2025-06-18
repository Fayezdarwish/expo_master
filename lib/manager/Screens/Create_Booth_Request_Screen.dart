import 'package:flutter/material.dart';

class CreateBoothRequestScreen extends StatefulWidget {
  @override
  _CreateBoothRequestScreenState createState() => _CreateBoothRequestScreenState();
}

class _CreateBoothRequestScreenState extends State<CreateBoothRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  String companyName = '';
  String contactPerson = '';
  String email = '';
  String phone = '';
  String description = '';
  int? selectedDepartmentId;

  List<Map<String, dynamic>> departments = [
    // سيتم استبدالها بالداتا الحقيقية من السيرفر
    {'id': 1, 'name': 'تقنية'},
    {'id': 2, 'name': 'فن'},
  ];

  void submitRequest() {
    if (_formKey.currentState!.validate()) {
      // تنفيذ إرسال البيانات إلى السيرفر
      print('Submitting booking request...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلب إنشاء جناح')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم الشركة'),
                onChanged: (val) => companyName = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم الشخص المسؤول'),
                onChanged: (val) => contactPerson = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => email = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                onChanged: (val) => phone = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              DropdownButtonFormField<int>(
                value: selectedDepartmentId,
                hint: Text('اختر القسم'),
                onChanged: (val) => setState(() => selectedDepartmentId = val),
                items: departments.map((dept) {
                  return DropdownMenuItem<int>(
                    value: dept['id'],
                    child: Text(dept['name']),
                  );
                }).toList(),
                validator: (val) => val == null ? 'مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'وصف الجناح'),
                maxLines: 4,
                onChanged: (val) => description = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitRequest,
                child: Text('إرسال الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
