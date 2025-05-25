import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class CreateDepartmentScreen extends StatefulWidget {
  final int managerId;

  const CreateDepartmentScreen({super.key, required this.managerId});

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  bool isLoading = false;

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

  void handleCreateDepartment() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final startDate = startDateController.text.trim();
    final endDate = endDateController.text.trim();

    if (name.isEmpty || description.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      showMessage("الرجاء ملء جميع الحقول");
      return;
    }

    setState(() => isLoading = true);

    final result = await VisitorApi.createDepartment(
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      managerId: widget.managerId,
    );

    setState(() => isLoading = false);

    if (result != null) {
      showMessage("تم إنشاء القسم بنجاح", isSuccess: true);
      Navigator.pop(context);
    } else {
      showMessage("فشل في إنشاء القسم");
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
      appBar: AppBar(title: const Text("إنشاء قسم جديد")),
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
                  onPressed: handleCreateDepartment,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("إنشاء القسم"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
