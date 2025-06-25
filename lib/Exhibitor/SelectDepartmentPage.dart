import 'package:flutter/material.dart';
import '../visitor/api/visitor_api.dart';

class SelectDepartmentPage extends StatefulWidget {
  @override
  _SelectDepartmentPageState createState() => _SelectDepartmentPageState();
}

class _SelectDepartmentPageState extends State<SelectDepartmentPage> {
  List<Map<String, dynamic>>? departments;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final data = await VisitorApi.getAllDepartments();
    setState(() {
      departments = data;
      isLoading = false;
    });
  }

  void onDepartmentSelected(Map<String, dynamic> department) {
    Navigator.pushNamed(context, '/exhibitorRequestForm', arguments: department);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقسام المتاحة'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : departments == null || departments!.isEmpty
          ? Center(child: Text('لا توجد أقسام حالياً'))
          : ListView.builder(
        itemCount: departments!.length,
        itemBuilder: (context, index) {
          final dept = departments![index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(dept['name']),
              subtitle: Text(dept['description'] ?? ''),
              trailing: ElevatedButton(
                onPressed: () => onDepartmentSelected(dept),
                child: Text('اختيار'),
              ),
            ),
          );
        },
      ),
    );
  }
}
