import 'package:flutter/material.dart';
import 'package:expo_master/utils/token_storage.dart';

import '../data/exibition_api.dart';
import '../data/exibition_model.dart';


class CreateExhibition extends StatefulWidget {
  const CreateExhibition({super.key});

  @override
  State<CreateExhibition> createState() => _CreateExhibitionState();
}

class _CreateExhibitionState extends State<CreateExhibition> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

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

  Future<void> _handleCreate() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final startDate = _startDateController.text.trim();
    final endDate = _endDateController.text.trim();

    if (name.isEmpty || description.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول'), backgroundColor: Colors.red),
      );
      return;
    }

    final token = await TokenStorage.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم العثور على توكن'), backgroundColor: Colors.red),
      );
      return;
    }

    final exhibition = Exhibition(
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
    );

    final success = await ExhibitionApi.createExhibition(exhibition, token);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء المعرض بنجاح'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إنشاء المعرض'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء معرض جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel('اسم المعرض'),
            _buildTextField(controller: _nameController, hint: 'أدخل اسم المعرض'),

            const SizedBox(height: 16),
            _buildLabel('وصف المعرض'),
            _buildTextField(controller: _descriptionController, hint: 'أدخل وصف المعرض', maxLines: 3),

            const SizedBox(height: 16),
            _buildLabel('تاريخ البداية'),
            _buildDateField(controller: _startDateController, hint: 'اختر تاريخ البداية'),

            const SizedBox(height: 16),
            _buildLabel('تاريخ النهاية'),
            _buildDateField(controller: _endDateController, hint: 'اختر تاريخ النهاية'),

            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _handleCreate,
              icon: const Icon(Icons.check_circle),
              label: const Text('إنشاء المعرض'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDateField({required TextEditingController controller, required String hint}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
