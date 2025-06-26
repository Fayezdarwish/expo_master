import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VendorBoothTasksScreen extends StatefulWidget {
  final int exhibitorId; // رقم العارض
  final int sectionId; // رقم الجناح

  VendorBoothTasksScreen({required this.exhibitorId, required this.sectionId});

  @override
  _VendorBoothTasksScreenState createState() => _VendorBoothTasksScreenState();
}

class _VendorBoothTasksScreenState extends State<VendorBoothTasksScreen> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productDescription = '';
  double? productPrice;

  void addProduct() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "exhibitorId": widget.exhibitorId,
        "sectionId": widget.sectionId,
        "productName": productName,
        "description": productDescription,
        "price": productPrice,
      };

      final response = await ApiService.post('/add-products', data);

      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إضافة المنتج بنجاح')));
        setState(() {
          productName = '';
          productDescription = '';
          productPrice = null;
        });
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إضافة المنتج')));
      }
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
