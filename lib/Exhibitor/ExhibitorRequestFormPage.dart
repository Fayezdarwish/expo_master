import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class ExhibitorRequestFormPage extends StatefulWidget {
  @override
  _ExhibitorRequestFormPageState createState() => _ExhibitorRequestFormPageState();
}

class _ExhibitorRequestFormPageState extends State<ExhibitorRequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  String exhibitionName = '';
  String contactPhone = '';
  String notes = '';
  bool isLoading = false;

  late Map<String, dynamic> selectedDepartment;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedDepartment = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  Future<void> submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    // إرسال الطلب (تحتاج تعديل endpoint وبيانات ال API حسب الباك عندك)
    final token = await TokenStorage.getToken();
    if (token == null) {
      // إدارة حالة عدم وجود توكن
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: لم يتم تسجيل الدخول')));
      setState(() => isLoading = false);
      return;
    }

    final response = await VisitorApi.submitExhibitorRequest(
      exhibitionName: exhibitionName,
      contactPhone: contactPhone,
      notes: notes,
      sectionId: selectedDepartment['id'],
      token: token,
    );

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      // نجاح الطلب -> الانتقال لشاشة حالة الطلب
      Navigator.pushReplacementNamed(context, '/requestStatus', arguments: response['id']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء إرسال الطلب')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلب العارض في قسم: ${selectedDepartment['name']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم المعرض'),
                validator: (val) =>
                val == null || val.isEmpty ? 'يرجى إدخال اسم المعرض' : null,
                onSaved: (val) => exhibitionName = val!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                validator: (val) =>
                val == null || val.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                onSaved: (val) => contactPhone = val!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'ملاحظات (اختياري)'),
                maxLines: 3,
                onSaved: (val) => notes = val ?? '',
              ),
              SizedBox(height: 24),
              if (isLoading) CircularProgressIndicator(),
              if (!isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: submitRequest,
                      child: Text('تثبيت الطلب'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // دفع الإيجار غير مفعل حتى الموافقة
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('انتظر موافقة مدير القسم أولاً')));
                      },
                      child: Text('دفع الإيجار'),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
