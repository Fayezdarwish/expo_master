import 'package:flutter/material.dart';

/// شاشة إنشاء جناح جديد بعد إتمام الدفع النهائي
class VendorCreateBoothScreen extends StatefulWidget {
  @override
  _VendorCreateBoothScreenState createState() => _VendorCreateBoothScreenState();
}

class _VendorCreateBoothScreenState extends State<VendorCreateBoothScreen> {
  final _formKey = GlobalKey<FormState>();
  String boothName = '';

  /// حفظ بيانات الجناح على السيرفر (يمكن إضافة اتصال API لاحقاً)
  void submitBooth() {
    if (_formKey.currentState!.validate()) {
      // بعد الحفظ، يمكن الانتقال لصفحة الجناح
      Navigator.pushReplacementNamed(context, '/vendor_booth_tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء جناح جديد')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم الجناح'),
                onChanged: (val) => boothName = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitBooth,
                child: Text('إنشاء الجناح'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
