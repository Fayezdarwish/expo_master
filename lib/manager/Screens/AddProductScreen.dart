import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';
import '../api/ProductsApi.dart';


class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  double price = 0.0;
  int? departmentId;

  bool isLoading = false;
  List<Map<String, dynamic>> departments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final result = await VisitorApi.getAllDepartments();
    if (result != null) {
      setState(() => departments = result);
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate() || departmentId == null) return;

    setState(() => isLoading = true);

    final ok = await ProductsApi.createProduct(
      name: name,
      description: description,
      price: price,
      departmentId: departmentId!,
    );

    setState(() => isLoading = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة المنتج')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة منتج')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: departments.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم المنتج'),
                onChanged: (v) => name = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'الوصف'),
                onChanged: (v) => description = v,
                validator: (v) => v == null || v.isEmpty ?'مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'السعر'),
                keyboardType: TextInputType.number,
                onChanged: (v) => price = double.tryParse(v) ?? 0.0,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'القسم'),
                value: departmentId,
                items: departments.map((dept) {
                  return DropdownMenuItem<int>(
                    value: dept['id'],
                    child: Text(dept['name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => departmentId = val),
                validator: (v) => v == null ? 'اختر قسماً' : null,
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: save,
                child: Text('حفظ المنتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
