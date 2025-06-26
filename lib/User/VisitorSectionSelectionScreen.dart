import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';
import 'TicketPurchaseScreen.dart';

class VisitorSectionSelectionScreen extends StatefulWidget {
  final int departmentId;
  final String departmentName;

  const VisitorSectionSelectionScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  State<VisitorSectionSelectionScreen> createState() => _VisitorSectionSelectionScreenState();
}

class _VisitorSectionSelectionScreenState extends State<VisitorSectionSelectionScreen> {
  List sections = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  Future<void> fetchSections() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم العثور على توكن المستخدم')),
      );
      return;
    }

    final response = await ApiService.getWithToken('/visitor/sections/${widget.departmentId}', token);
    if (response != null && response.statusCode == 200) {
      setState(() {
        sections = response.data['sections'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل الأقسام')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الأقسام في ${widget.departmentName}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sections.isEmpty
          ? const Center(child: Text('لا توجد أقسام متاحة'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final section = sections[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: ListTile(
                title: Text(section['name'], style: Theme.of(context).textTheme.titleLarge),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TicketPurchaseScreen(
                        departmentId: widget.departmentId,
                        sectionId: section['id'],
                        sectionName: section['name'],
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
