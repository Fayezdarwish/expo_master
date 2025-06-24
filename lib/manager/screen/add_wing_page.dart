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

    @override
    void initState() {
      super.initState();
      fetchParticipants();
    }

    Future<void> fetchParticipants() async {
      final response = await ApiService.get('/participants?is_paid=true');
      if (response != null) {
        setState(() {
          paidParticipants = response.data;
        });
      }
    }

    Future<void> addWing() async {
      await ApiService.postWithToken('/wings', {
        'name': nameController.text,
        'participant_id': selectedParticipant,
      }, 'YOUR_TOKEN'); // استبدل بـ توكن حقيقي

      Navigator.pop(context);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('إضافة جناح')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الجناح'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedParticipant,
                hint: const Text('اختر عارضًا'),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: addWing,
                child: const Text('إضافة'),
              ),
            ],
          ),
        ),
      );
    }
  }
