import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  bool isLoading = false;

  Future<void> saveProduct() async {
    setState(() => isLoading = true);

    // هنا استدعاء API لإضافة المنتج باستخدام البيانات من الكنترولرز
    // مثال:
    // final response = await ApiService.postWithToken('/products/add', {...}, token);

    await Future.delayed(const Duration(seconds: 1)); // محاكاة انتظار

    setState(() => isLoading = false);

    // بعد الحفظ بنجاح ارجع للصفحة السابقة
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
      appBar: AppBar(title: const Text('إضافة منتج')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'الوصف')),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'السعر'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : saveProduct,
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}
