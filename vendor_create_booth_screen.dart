import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VendorCreateBoothScreen extends StatefulWidget {
  final int exhibitorId; // رقم العارض
  final int departmentId; // رقم القسم المختار

  VendorCreateBoothScreen({required this.exhibitorId, required this.departmentId});

  @override
  _VendorCreateBoothScreenState createState() => _VendorCreateBoothScreenState();
}

class _VendorCreateBoothScreenState extends State<VendorCreateBoothScreen> {
  final _formKey = GlobalKey<FormState>();
  String boothName = '';

  void submitBooth() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": boothName,
        "departments_id": widget.departmentId,
        "exhibitor_id": widget.exhibitorId,
      };

      final response = await ApiService.post('/create-wing', data);

      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إنشاء الجناح بنجاح')));
        Navigator.pushReplacementNamed(context, '/vendor_booth_tasks');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إنشاء الجناح')));
      }
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
