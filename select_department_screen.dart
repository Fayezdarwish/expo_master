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
  List<Map<String, dynamic>> filteredDepartments = [];
  bool isLoading = true;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRequest();
    _searchController.addListener(() {
      _filterDepartments(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getRequest() async {
    setState(() => isLoading = true);
    try {
      final data = await VisitorApi.getAllDepartmentsforexhibitor();
      if (data != null && data.isNotEmpty) {
        setState(() {
          departments = data;
          filteredDepartments = data;
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _filterDepartments(String query) {
    final filtered =
        departments.where((department) {
          final name = (department['name'] ?? '').toString().toLowerCase();
          final input = query.toLowerCase();
          return name.contains(input);
        }).toList();

    setState(() {
      searchQuery = query;
      filteredDepartments = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterDepartments('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر القسم')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                        : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredDepartments.isEmpty
                    ? const Center(child: Text('لا يوجد أقسام حالياً'))
                    : ListView.separated(
                      itemCount: filteredDepartments.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final department = filteredDepartments[index];
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
          ),
        ],
      ),
    );
  }
}
