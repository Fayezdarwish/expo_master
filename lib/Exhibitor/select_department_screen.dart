import 'package:flutter/material.dart';

class SelectDepartmentScreen extends StatelessWidget {
  const SelectDepartmentScreen({super.key});

  final List<Map<String, dynamic>> departments = const [
    {'id': 1, 'name': 'قسم الإلكترونيات'},
    {'id': 2, 'name': 'قسم الأزياء'},
    {'id': 3, 'name': 'قسم الأغذية'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر القسم')),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (_, index) {
          final department = departments[index];
          return ListTile(
            title: Text(department['name']),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/exhibitor/submit-request',
                arguments: department['id'], // تمرير id القسم فقط
              );
            },
          );
        },
      ),
    );
  }
}
