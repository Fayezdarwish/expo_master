// import 'package:flutter/material.dart';
// import '../../visitor/api/visitor_api.dart';
// import 'create_department_screen.dart';
//
// class ManageDepartmentsScreen extends StatefulWidget {
//   const ManageDepartmentsScreen({super.key});
//
//   @override
//   State<ManageDepartmentsScreen> createState() => _ManageDepartmentsScreenState();
// }
//
// class _ManageDepartmentsScreenState extends State<ManageDepartmentsScreen> {
//   List<Map<String, dynamic>> departments = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAllDepartments();
//   }
//
//   Future<void> fetchAllDepartments() async {
//     setState(() => isLoading = true);
//     final data = await VisitorApi.getAllDepartments();
//     if (data != null) departments = data;
//     setState(() => isLoading = false);
//   }
//
//   void confirmDelete(int id) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("تأكيد الحذف"),
//         content: const Text("هل أنت متأكد من حذف هذا القسم؟"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("إلغاء")),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("حذف")),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       final success = await VisitorApi.deleteDepartment(id);
//       final snackBar = SnackBar(
//         content: Text(success ? "تم الحذف" : "فشل الحذف"),
//         backgroundColor: success ? Colors.green : Colors.red,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       fetchAllDepartments();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إدارة الأقسام")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : departments.isEmpty
//           ? const Center(child: Text("لا يوجد أقسام"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: departments.length,
//         itemBuilder: (_, index) {
//           final dept = departments[index];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 12),
//             child: ListTile(
//               title: Text(dept['name']),
//               subtitle: Text(dept['description'] ?? ''),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.amber),
//                     onPressed: () async {
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => CreateDepartmentScreen(
//                             managerId: dept['manager_id'] ?? 0,
//                             isEdit: true,
//                             existingDepartment: dept,
//                           ),
//                         ),
//                       );
//                       fetchAllDepartments();
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.redAccent),
//                     onPressed: () => confirmDelete(dept['id']),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../visitor/api/visitor_api.dart';
import 'create_department_screen.dart';

class ManageDepartmentsScreen extends StatefulWidget {
  const ManageDepartmentsScreen({super.key});

  @override
  State<ManageDepartmentsScreen> createState() => _ManageDepartmentsScreenState();
}

class _ManageDepartmentsScreenState extends State<ManageDepartmentsScreen> {
  List<Map<String, dynamic>> apiDepartments = [];
  bool isLoading = true;

  // الأقسام الثابتة مع أيقونات مخصصة لكل قسم
  final List<Map<String, dynamic>> staticDepartments = [
    {'id': -1, 'name': 'أغذية', 'description': 'قسم الأغذية', 'icon': Icons.fastfood, 'isStatic': true},
    {'id': -2, 'name': 'إلكترونيات', 'description': 'قسم الإلكترونيات', 'icon': Icons.devices, 'isStatic': true},
    {'id': -3, 'name': 'جلود', 'description': 'قسم الجلود', 'icon': Icons.style, 'isStatic': true},
    {'id': -4, 'name': 'أقمشة', 'description': 'قسم الأقمشة', 'icon': Icons.texture, 'isStatic': true},
    {'id': -5, 'name': 'أثاث', 'description': 'قسم الأثاث', 'icon': Icons.weekend, 'isStatic': true},
    {'id': -6, 'name': 'ألعاب', 'description': 'قسم الألعاب', 'icon': Icons.toys, 'isStatic': true},
    {'id': -7, 'name': 'عطور', 'description': 'قسم العطور', 'icon': Icons.spa, 'isStatic': true},
    {'id': -8, 'name': 'كتب', 'description': 'قسم الكتب', 'icon': Icons.menu_book, 'isStatic': true},
    {'id': -9, 'name': 'مفروشات', 'description': 'قسم المفروشات', 'icon': Icons.chair, 'isStatic': true},
    {'id': -10, 'name': 'منتجات طبية', 'description': 'قسم المنتجات الطبية', 'icon': Icons.medical_services, 'isStatic': true},
    {'id': -11, 'name': 'أدوات مكتبية', 'description': 'قسم الأدوات المكتبية', 'icon': Icons.create, 'isStatic': true},
    {'id': -12, 'name': 'معدات صناعية', 'description': 'قسم المعدات الصناعية', 'icon': Icons.precision_manufacturing, 'isStatic': true},
    {'id': -13, 'name': 'حرف يدوية', 'description': 'قسم الحرف اليدوية', 'icon': Icons.handyman, 'isStatic': true},
    {'id': -14, 'name': 'معدات زراعية', 'description': 'قسم المعدات الزراعية', 'icon': Icons.agriculture, 'isStatic': true},
    {'id': -15, 'name': 'مجوهرات', 'description': 'قسم المجوهرات', 'icon': Icons.diamond, 'isStatic': true},
  ];

  List<Map<String, dynamic>> get combinedDepartments => [
    ...staticDepartments,
    ...apiDepartments,
  ];

  @override
  void initState() {
    super.initState();
    fetchAllDepartments();
  }

  Future<void> fetchAllDepartments() async {
    setState(() => isLoading = true);
    final data = await VisitorApi.getAllDepartments();
    if (data != null) apiDepartments = data;
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

  Widget _buildDepartmentTile(Map<String, dynamic> dept) {
    final isStatic = dept['isStatic'] == true;
    final iconData = dept['icon'] as IconData? ?? Icons.category;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: isStatic ? Colors.blue.shade100 : Colors.green.shade100,
          child: Icon(iconData, color: isStatic ? Colors.blue.shade700 : Colors.green.shade700, size: 28),
        ),
        title: Text(
          dept['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isStatic ? Colors.blue.shade900 : Colors.green.shade900,
          ),
        ),
        subtitle: dept['description'] != null
            ? Text(
          dept['description'],
          style: TextStyle(
            color: isStatic ? Colors.blueGrey.shade600 : Colors.green.shade600,
            fontSize: 14,
          ),
        )
            : null,
        trailing: isStatic
            ? const SizedBox(width: 24) // لا أزرار تعديل وحذف للأقسام الثابتة
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber),
              tooltip: 'تعديل القسم',
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
              tooltip: 'حذف القسم',
              onPressed: () => confirmDelete(dept['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة الأقسام"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : combinedDepartments.isEmpty
          ? const Center(child: Text("لا يوجد أقسام"))
          : RefreshIndicator(
        onRefresh: fetchAllDepartments,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: combinedDepartments.length,
          itemBuilder: (_, index) => _buildDepartmentTile(combinedDepartments[index]),
        ),
      ),
    );
  }
}
