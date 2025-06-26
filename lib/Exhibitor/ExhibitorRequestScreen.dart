import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/token_storage.dart';

class ExhibitorRequestScreen extends StatefulWidget {
  const ExhibitorRequestScreen({super.key});

  @override
  State<ExhibitorRequestScreen> createState() => _ExhibitorRequestScreenState();
}

class _ExhibitorRequestScreenState extends State<ExhibitorRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exhibitionNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  int? selectedDepartmentId;
  List departments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final response = await ApiService.getWithToken('/exhibitor/departments', token);
    if (response != null && response.statusCode == 200) {
      setState(() => departments = response.data['departments']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في جلب الأقسام')),
      );
    }
  }

  Future<void> submitRequest() async {
    if (!_formKey.currentState!.validate() || selectedDepartmentId == null) return;

    setState(() => isLoading = true);

    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
      );
      return;
    }

    final data = {
      "exhibitionName": _exhibitionNameController.text,
      "departmentId": selectedDepartmentId,
      "contactPhone": _contactPhoneController.text,
      "notes": _notesController.text,
    };

    final response = await ApiService.postWithToken('/exhibitor/create-request', data, token);

    setState(() => isLoading = false);

    if (response != null && response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إرسال الطلب بنجاح"), backgroundColor: Colors.green),
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل في إرسال الطلب")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("طلب المشاركة")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('أدخل بيانات طلبك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(label: "اسم المعرض", controller: _exhibitionNameController),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "القسم", border: OutlineInputBorder()),
                items: departments.map<DropdownMenuItem<int>>((dep) {
                  return DropdownMenuItem(value: dep['id'], child: Text(dep['name']));
                }).toList(),
                onChanged: (val) => setState(() => selectedDepartmentId = val),
                validator: (val) => val == null ? "يرجى اختيار قسم" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "رقم الهاتف",
                controller: _contactPhoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "ملاحظات",
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: "إرسال الطلب",
                onPressed: submitRequest,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// تعريف CustomTextField بسيط
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (label == "ملاحظات") return null; // الملاحظات غير إلزامية
          return 'يرجى إدخال $label';
        }
        return null;
      },
    );
  }
}

// تعريف CustomButton بسيط مع حالة تحميل
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: isLoading
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      )
          : Text(label),
    );
  }
}

