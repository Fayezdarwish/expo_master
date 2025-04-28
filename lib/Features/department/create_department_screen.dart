import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';

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

  // دالة لتنسيق التاريخ
  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // دالة لاختيار التاريخ
  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
    }
  }

  // دالة إرسال بيانات القسم
  void handleCreateDepartment() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final startDate = startDateController.text.trim();
    final endDate = endDateController.text.trim();

    if (name.isEmpty || description.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      showMessage("الرجاء تعبئة جميع الحقول");
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
      Navigator.pop(context); // الرجوع بعد النجاح
    } else {
      showMessage("فشل إنشاء القسم");
    }
  }

  // دالة عرض رسالة
  void showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء قسم جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add_business, size: 64),
              const SizedBox(height: 16),
              Text("معلومات القسم", style: textTheme.titleLarge),
              const SizedBox(height: 32),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القسم',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف القسم',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: startDateController,
                readOnly: true,
                onTap: () => _pickDate(startDateController),
                decoration: const InputDecoration(
                  labelText: 'تاريخ البداية',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: endDateController,
                readOnly: true,
                onTap: () => _pickDate(endDateController),
                decoration: const InputDecoration(
                  labelText: 'تاريخ النهاية',
                  prefixIcon: Icon(Icons.calendar_today),
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
