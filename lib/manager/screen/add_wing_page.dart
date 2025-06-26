import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddWingPage extends StatefulWidget {
  const AddWingPage({super.key});

  @override
  State<AddWingPage> createState() => _AddWingPageState();
}

class _AddWingPageState extends State<AddWingPage> {
  final TextEditingController nameController = TextEditingController();
  String? selectedParticipant;
  List<dynamic> paidParticipants = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future<void> fetchParticipants() async {
    setState(() => isLoading = true);
    final response = await ApiService.get('/participants?is_paid=true');
    if (response != null) {
      setState(() {
        paidParticipants = response.data;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل العارضين المدفوعين')),
      );
    }
  }

  Future<void> addWing() async {
    if (nameController.text.isEmpty || selectedParticipant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء كل الحقول')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await ApiService.postWithToken('/wings', {
        'name': nameController.text.trim(),
        'participant_id': selectedParticipant,
      }, 'YOUR_TOKEN'); // استبدل بالتوكن الصحيح

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء إضافة الجناح')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة جناح')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الجناح',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wb_sunny_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedParticipant,
                decoration: const InputDecoration(
                  labelText: 'اختر عارضًا',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: paidParticipants.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedParticipant = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة الجناح'),
                  onPressed: addWing,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
