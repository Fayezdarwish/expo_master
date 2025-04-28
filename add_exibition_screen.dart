import 'package:flutter/material.dart';

class CreateExhibition extends StatefulWidget {
  const CreateExhibition({super.key});

  @override
  State<CreateExhibition> createState() => _CreateExhibitionState();
}

class _CreateExhibitionState extends State<CreateExhibition> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _idManagerController = TextEditingController();

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
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
    }
  }

  void _createExhibition() {
    final int? idManager = int.tryParse(_idManagerController.text.trim());

    if (idManager == null) {
      showMessage("يرجى إدخال رقم مدير صحيح");
      return;
    }


    print("تم إنشاء المعرض بنجاح باستخدام ID المدير: $idManager");
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء معرض جديد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('اسم المعرض', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(hintText: 'أدخل اسم المعرض'),
            ),
            const SizedBox(height: 16),

            Text('وصف المعرض', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(hintText: 'أدخل وصف المعرض'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            Text('تاريخ البداية', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _startDateController,
              readOnly: true,
              onTap: () => _pickDate(_startDateController),
              decoration: const InputDecoration(hintText: 'اختر تاريخ البداية'),
            ),
            const SizedBox(height: 16),

            Text('تاريخ النهاية', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _endDateController,
              readOnly: true,
              onTap: () => _pickDate(_endDateController),
              decoration: const InputDecoration(hintText: 'اختر تاريخ النهاية'),
            ),
            const SizedBox(height: 16),


            Text('ID المدير', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _idManagerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'أدخل ID المدير'),
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _createExhibition,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('إنشاء المعرض'),
            ),

          ],
        ),
      ),
    );
  }
}
