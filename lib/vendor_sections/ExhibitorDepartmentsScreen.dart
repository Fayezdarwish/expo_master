import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class ExhibitorDepartmentsScreen extends StatefulWidget {
  const ExhibitorDepartmentsScreen({super.key});

  @override
  State<ExhibitorDepartmentsScreen> createState() => _ExhibitorDepartmentsScreenState();
}

class _ExhibitorDepartmentsScreenState extends State<ExhibitorDepartmentsScreen> {
  List<Map<String, dynamic>> departments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDepartments(); // جلب الأقسام عند تحميل الشاشة
  }

  // جلب الأقسام من API
  Future<void> fetchDepartments() async {
    final data = await VisitorApi.getAllDepartments();
    if (data != null) {
      setState(() {
        departments = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر القسم')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // مؤشر تحميل
          : ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return ListTile(
            title: Text(dept['name'], style: Theme.of(context).textTheme.titleLarge),
            subtitle: Text(dept['description'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              // عند الضغط على قسم يتم الانتقال للنموذج مع تمرير بيانات القسم
              Navigator.pushNamed(
                context,
                '/exhibitorRequestForm',
                arguments: dept,
              );
            },
          );
        },
      ),
    );
  }
}
