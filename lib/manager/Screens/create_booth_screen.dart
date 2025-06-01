import 'package:flutter/material.dart';
import '../api/section_manager_api.dart';

class CreateBoothScreen extends StatefulWidget {
  final int sectionId;

  const CreateBoothScreen({super.key, required this.sectionId});

  @override
  State<CreateBoothScreen> createState() => _CreateBoothScreenState();
}

class _CreateBoothScreenState extends State<CreateBoothScreen> {
  final nameController = TextEditingController();
  final sizeController = TextEditingController();
  final locationController = TextEditingController();
  bool isLoading = false;

  void handleCreate() async {
    final name = nameController.text.trim();
    final size = sizeController.text.trim();
    final location = locationController.text.trim();

    if (name.isEmpty || size.isEmpty || location.isEmpty) {
      showMessage("يرجى تعبئة جميع الحقول");
      return;
    }

    setState(() => isLoading = true);

    final result = await SectionManagerApi.createBooth(
      sectionId: widget.sectionId,
      name: name,
      size: size,
      location: location,
    );

    setState(() => isLoading = false);

    if (result) {
      showMessage("تم إنشاء الجناح بنجاح", isSuccess: true);
      Navigator.pop(context);
    } else {
      showMessage("فشل في إنشاء الجناح");
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
      appBar: AppBar(title: const Text("إنشاء جناح جديد")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "اسم الجناح",
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: sizeController,
                decoration: const InputDecoration(
                  labelText: "حجم الجناح",
                  prefixIcon: Icon(Icons.aspect_ratio),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "موقع الجناح",
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: handleCreate,
                  icon: const Icon(Icons.add),
                  label: const Text("إنشاء الجناح"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
