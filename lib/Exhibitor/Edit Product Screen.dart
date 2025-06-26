import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product ?? {};
    _nameController = TextEditingController(text: product['name'] ?? '');
    _descController = TextEditingController(text: product['description'] ?? '');
    _priceController = TextEditingController(text: product['price']?.toString() ?? '');
  }

  Future<void> updateProduct() async {
    setState(() => isLoading = true);

    // هنا استدعاء API لتحديث المنتج بالبيانات الجديدة
    // final response = await ApiService.putWithToken('/products/${widget.product['id']}', {...}, token);

    await Future.delayed(const Duration(seconds: 1)); // محاكاة انتظار

    setState(() => isLoading = false);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل المنتج')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'الوصف')),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'السعر'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : updateProduct,
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('تعديل'),
            ),
          ],
        ),
      ),
    );
  }
}
