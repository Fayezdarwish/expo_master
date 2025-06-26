import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/token_storage.dart';

class ExhibitorRequestScreen extends StatefulWidget {
  @override
  _ExhibitorRequestScreenState createState() => _ExhibitorRequestScreenState();
}

class _ExhibitorRequestScreenState extends State<ExhibitorRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _exhibitionNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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
    if (token == null) {
      // handle no token case, maybe redirect to login
      return;
    }
    final response = await ApiService.getWithToken('/exhibitor/departments', token);

    if (response != null && response.statusCode == 200) {
      setState(() {
        departments = response.data['departments'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب الأقسام')),
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
        SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
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
        SnackBar(content: Text("تم إرسال الطلب بنجاح")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في إرسال الطلب")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("طلب المشاركة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: "اسم المعرض",
                controller: _exhibitionNameController,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "القسم",
                  border: OutlineInputBorder(),
                ),
                items: departments.map<DropdownMenuItem<int>>((dep) {
                  return DropdownMenuItem(
                    value: dep['id'],
                    child: Text(dep['name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedDepartmentId = val),
                validator: (val) => val == null ? "يرجى اختيار قسم" : null,
              ),
              SizedBox(height: 12),
              CustomTextField(
                label: "رقم الهاتف",
                controller: _contactPhoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              CustomTextField(
                label: "ملاحظات",
                controller: _notesController,
                maxLines: 3,
              ),
              SizedBox(height: 24),
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

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: isLoading
          ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text(label),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const CustomTextField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
