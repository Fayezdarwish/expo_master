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

    if (widget.isEdit && widget.existingDepartment != null) {
      final dept = widget.existingDepartment!;
      nameController.text = dept['name'] ?? '';
      descriptionController.text = dept['description'] ?? '';
      startDateController.text = dept['startDate']?.split('T')[0] ?? '';
      endDateController.text = dept['endDate']?.split('T')[0] ?? '';
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
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
      showMessage("الرجاء تعبئة جميع الحقول");
      return;
    }

    setState(() => isLoading = true);

    bool success = false;

    if (widget.isEdit && widget.existingDepartment != null) {
      success = await VisitorApi.updateDepartment(
        id: widget.existingDepartment!['id'],
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
      showMessage("فشلت العملية");
    }
  }

  void showMessage(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isSuccess ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? "تعديل القسم" : "إنشاء قسم")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildField("اسم القسم", nameController, icon: Icons.title),
              buildField("وصف القسم", descriptionController, icon: Icons.description, maxLines: 3),
              buildDateField("تاريخ البداية", startDateController),
              buildDateField("تاريخ النهاية", endDateController),
              const SizedBox(height: 32),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: handleSubmit,
                icon: const Icon(Icons.check_circle),
                label: Text(widget.isEdit ? "حفظ التعديلات" : "إنشاء القسم"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {IconData? icon, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => pickDate(controller),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}
