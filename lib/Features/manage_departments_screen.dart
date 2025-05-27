import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';
import 'create_department_screen.dart';

class ManageDepartmentsScreen extends StatefulWidget {
  const ManageDepartmentsScreen({super.key});

  @override
  State<ManageDepartmentsScreen> createState() => _ManageDepartmentsScreenState();
}

class _ManageDepartmentsScreenState extends State<ManageDepartmentsScreen> {
  List<Map<String, dynamic>> departments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllDepartments();
  }

  Future<void> fetchAllDepartments() async {
    setState(() => isLoading = true);
    final data = await VisitorApi.fetchDepartments();
    if (data != null) {
      departments = data;
    }
    setState(() => isLoading = false);
  }

  void confirmDelete(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد أنك تريد حذف هذا القسم؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("إلغاء")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("حذف")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await VisitorApi.deleteDepartment(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم حذف القسم"), backgroundColor: Colors.green),
        );
        fetchAllDepartments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل الحذف"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("إدارة الأقسام")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : departments.isEmpty
          ? const Center(child: Text("لا يوجد أقسام حالياً"))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return ListTile(
            title: Text(dept['name'], style: textTheme.titleLarge),
            subtitle: Text(dept['description'] ?? ""),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateDepartmentScreen(
                          managerId: dept['manager_id'] ?? 0,
                          isEdit: true,
                          existingDepartment: dept,
                        ),
                      ),
                    );
                    fetchAllDepartments();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => confirmDelete(dept['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
