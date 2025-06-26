import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../visitor/api/visitor_api.dart';

class SelectDepartmentScreen extends StatefulWidget {
  const SelectDepartmentScreen({super.key});

  @override
  State<SelectDepartmentScreen> createState() => _SelectDepartmentScreenState();
}

class _SelectDepartmentScreenState extends State<SelectDepartmentScreen> {
  List<Map<String, dynamic>> departments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRequest();
  }

  Future<void> getRequest() async {
    setState(() => isLoading = true);
    try {
      final data = await VisitorApi.getAllDepartmentsforexhibitor();
      if (data != null && data.isNotEmpty) {
        setState(() {
          departments = data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _showError('لا يوجد أقسام حالياً.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError('حدث خطأ أثناء تحميل الأقسام.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر القسم')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : departments.isEmpty
          ? const Center(child: Text('لا يوجد أقسام حالياً'))
          : ListView.separated(
        itemCount: departments.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final department = departments[index];
          return ListTile(
            title: Text(department['name'] ?? 'بدون اسم'),
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
