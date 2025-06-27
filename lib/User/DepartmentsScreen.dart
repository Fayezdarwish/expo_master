import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';
import 'SectionsScreen.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> with SingleTickerProviderStateMixin {
  List departments = [];
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchDepartments();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchDepartments() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() => isLoading = false);
    }

    final response = await ApiService.getWithToken('/visitor/departments', token ?? '');
    if (response != null && response.statusCode == 200) {
      setState(() {
        departments = response.data['departments'];
        isLoading = false;
      });
      _controller.forward();
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحميل الأقسام')));
    }
  }

  IconData _getIconForDepartment(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('الكترونيات') || lowerName.contains('electronics')) {
      return Icons.devices;
    } else if (lowerName.contains('اغذية') || lowerName.contains('food')) {
      return Icons.fastfood;
    } else if (lowerName.contains('جلود')) {
      return Icons.shopping_bag;
    } else if (lowerName.contains('اقمشة')) {
      return Icons.style;
    } else if (lowerName.contains('اثاث') || lowerName.contains('furniture')) {
      return Icons.chair;
    } else if (lowerName.contains('العاب') || lowerName.contains('toys')) {
      return Icons.toys;
    } else if (lowerName.contains('عطور')) {
      return Icons.spa;
    } else if (lowerName.contains('كتب') || lowerName.contains('books')) {
      return Icons.book;
    } else if (lowerName.contains('مفروشات')) {
      return Icons.bed;
    } else if (lowerName.contains('طبية') || lowerName.contains('medical')) {
      return Icons.medical_services;
    } else if (lowerName.contains('مجوهرات')) {
      return Icons.diamond;
    }
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('اختيار القسم'),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : departments.isEmpty
          ? const Center(child: Text('لا توجد أقسام', style: TextStyle(fontSize: 18)))
          : FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          itemCount: departments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final dept = departments[index];
            final icon = _getIconForDepartment(dept['name'] ?? '');
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              shadowColor: Colors.blue.withOpacity(0.2),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF4A90E2).withOpacity(0.15),
                  child: Icon(icon, color: const Color(0xFF4A90E2), size: 26),
                ),
                title: Text(
                  dept['name'] ?? 'بدون اسم',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4A90E2)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SectionsScreen(
                        departmentId: dept['id'],
                        departmentName: dept['name'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
