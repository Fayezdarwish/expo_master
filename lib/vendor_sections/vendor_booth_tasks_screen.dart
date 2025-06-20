import 'package:flutter/material.dart';

/// شاشة المهام للعارض لإضافة المنتجات داخل جناحه
class VendorBoothTasksScreen extends StatefulWidget {
  @override
  _VendorBoothTasksScreenState createState() => _VendorBoothTasksScreenState();
}

class _VendorBoothTasksScreenState extends State<VendorBoothTasksScreen> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productDescription = '';
  double? productPrice;

  /// إضافة منتج جديد (يمكن ربطه لاحقاً بالـ API)
  void addProduct() {
    if (_formKey.currentState!.validate()) {
      // إضافة المنتج (مثلاً إرسال بياناته للسيرفر)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إضافة المنتج')));
      // إعادة تعيين الحقول
      setState(() {
        productName = '';
        productDescription = '';
        productPrice = null;
      });
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مهام العارض - إضافة المنتجات')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم المنتج'),
                onChanged: (val) => productName = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'وصف المنتج'),
                onChanged: (val) => productDescription = val,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'سعر المنتج'),
                keyboardType: TextInputType.number,
                onChanged: (val) => productPrice = double.tryParse(val),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'مطلوب';
                  if (double.tryParse(val) == null) return 'يجب إدخال رقم صحيح';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: Text('إضافة المنتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
