import 'package:flutter/material.dart';
import '../api/ProductsApi.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late String name, description;
  late double price;
  late int departmentId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    name = p['name'] ?? '';
    description = p['description'] ?? '';
    price = (p['price'] is int) ? (p['price'] as int).toDouble() : (p['price'] ?? 0.0);
    departmentId = p['department_id'] ?? 0;
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final ok = await ProductsApi.updateProduct(
      productId: widget.product['id'],
      name: name,
      description: description,
      price: price,
      departmentId: departmentId,
    );

    setState(() => isLoading = false);

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تعديل المنتج')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل المنتج')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'اسم المنتج'),
                onChanged: (v) => name = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'الوصف'),
                onChanged: (v) => description = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(labelText: 'السعر'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final val = double.tryParse(v);
                  if (val != null) price = val;
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مطلوب';
                  if (double.tryParse(v) == null) return 'يجب إدخال رقم صحيح';
                  return null;
                },
              ),
              TextFormField(
                initialValue: departmentId.toString(),
                decoration: const InputDecoration(labelText: 'رقم القسم'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final val = int.tryParse(v);
                  if (val != null) departmentId = val;
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مطلوب';
                  if (int.tryParse(v) == null) return 'يجب إدخال رقم صحيح';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: save, child: const Text('حفظ التعديل')),
            ],
          ),
        ),
      ),
    );
  }
}
