import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class DepartmentsListScreen extends StatefulWidget {
  const DepartmentsListScreen({super.key});

  @override
  State<DepartmentsListScreen> createState() => _DepartmentsListScreenState();
}

class _DepartmentsListScreenState extends State<DepartmentsListScreen> {
  List<Map<String, dynamic>> departments = [];

  @override
  void initState() {
    super.initState();
    loadDepartments();
  }

  void loadDepartments() async {
    final list = await VisitorApi.getAllDepartments();
    if (list != null) {
      setState(() => departments = list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر القسم')),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return ListTile(
            title: Text(dept['name']),
            subtitle: Text(dept['description']),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/exhibitor/request_form',
                arguments: dept,
              );
            },
          );
        },
      ),
    );
  }
}
