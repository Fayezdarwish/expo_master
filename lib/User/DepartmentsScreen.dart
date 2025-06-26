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
    // فرضًا الزائر يحصل على توكن مؤقت أو يمكن حذف شرط التوكن لو API يسمح
    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      // يمكن هنا توليد توكن مؤقت أو السماح بدون توكن حسب النظام
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار القسم')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : departments.isEmpty
          ? const Center(child: Text('لا توجد أقسام'))
          : FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          itemCount: departments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final dept = departments[index];
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                title: Text(
                  dept['name'],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary),
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
