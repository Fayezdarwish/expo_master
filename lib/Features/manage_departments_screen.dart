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
    if (data != null) departments = data;
    setState(() => isLoading = false);
  }

  void confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا القسم؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("إلغاء")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("حذف")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await VisitorApi.deleteDepartment(id);
      final snackBar = SnackBar(
        content: Text(success ? "تم الحذف" : "فشل الحذف"),
        backgroundColor: success ? Colors.green : Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      fetchAllDepartments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إدارة الأقسام")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : departments.isEmpty
          ? const Center(child: Text("لا يوجد أقسام"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: departments.length,
        itemBuilder: (_, index) {
          final dept = departments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(dept['name']),
              subtitle: Text(dept['description'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateDepartmentScreen(
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
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => confirmDelete(dept['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
