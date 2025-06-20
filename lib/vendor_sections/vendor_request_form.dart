import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

/// شاشة تعبئة نموذج طلب إنشاء جناح في قسم معين
class VendorRequestForm extends StatefulWidget {
  final int sectionId;
  VendorRequestForm({required this.sectionId});

  @override
  _VendorRequestFormState createState() => _VendorRequestFormState();
}

class _VendorRequestFormState extends State<VendorRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String tradeName = '';
  String activity = '';
  String contact = '';

  /// إرسال الطلب للسيرفر
  void submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final token = await TokenStorage.getToken() ?? '';
      final response = await ApiService.postWithToken(
        '/vendor/request',
        {
          'section_id': widget.sectionId,
          'trade_name': tradeName,
          'activity': activity,
          'contact': contact,
        },
        token,
      );

      if (response != null && response.statusCode == 200) {
        // الانتقال لشاشة الدفع الأولى بعد إرسال الطلب
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VendorInitialPaymentScreen()),
        );
      } else {
        // عرض خطأ في حال فشل الطلب
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إرسال الطلب، حاول لاحقاً')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلب إنشاء جناح')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'الاسم التجاري'),
                onChanged: (val) => tradeName = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'نوع النشاط'),
                onChanged: (val) => activity = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'معلومات التواصل'),
                onChanged: (val) => contact = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitRequest,
                child: Text('تثبيت الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
