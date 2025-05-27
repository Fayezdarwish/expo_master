import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class CreateDepartmentScreen extends StatefulWidget {
  final int managerId;
  final bool isEdit;
  final Map<String, dynamic>? existingDepartment;

  const CreateDepartmentScreen({
    super.key,
    required this.managerId,
    this.isEdit = false,
    this.existingDepartment,
  });

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // تعبئة البيانات إذا تعديل
    if (widget.isEdit && widget.existingDepartment != null) {
      final dept = widget.existingDepartment!;
      nameController.text = dept['name'] ?? '';
      descriptionController.text = dept['description'] ?? '';
      startDateController.text = dept['startDate']?.split('T')[0] ?? '';
      endDateController.text = dept['endDate']?.split('T')[0] ?? '';
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void handleSubmit() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final startDate = startDateController.text.trim();
    final endDate = endDateController.text.trim();

    if (name.isEmpty || description.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      showMessage("الرجاء ملء جميع الحقول");
      return;
    }

    setState(() => isLoading = true);

    bool success = false;

    if (widget.isEdit && widget.existingDepartment != null) {
      final id = widget.existingDepartment!['id'];
      success = await VisitorApi.updateDepartment(
        id: id,
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        managerId: widget.managerId,
      );
    } else {
      final result = await VisitorApi.createDepartment(
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        managerId: widget.managerId,
      );
      success = result != null;
    }

    setState(() => isLoading = false);

    if (success) {
      showMessage("تم الحفظ بنجاح", isSuccess: true);
      Navigator.pop(context);
    } else {
      showMessage("فشل في العملية");
    }
  }

  void showMessage(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isSuccess ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit ? "تعديل بيانات القسم" : "إنشاء قسم جديد";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القسم',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'وصف القسم',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: startDateController,
                readOnly: true,
                onTap: () => pickDate(startDateController),
                decoration: const InputDecoration(
                  labelText: 'تاريخ البداية',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: endDateController,
                readOnly: true,
                onTap: () => pickDate(endDateController),
                decoration: const InputDecoration(
                  labelText: 'تاريخ النهاية',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: handleSubmit,
                  icon: const Icon(Icons.check_circle),
                  label: Text(widget.isEdit ? "حفظ التعديلات" : "إنشاء القسم"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
