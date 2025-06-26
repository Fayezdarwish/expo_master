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
      body: ListView.separated(
        itemCount: departments.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final department = departments[index];
          return ListTile(
            title: Text(department['name']),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/exhibitor/submit-request',
                arguments: department['id'],
              );
            },
          );
        },
      ),
    );
  }
}
