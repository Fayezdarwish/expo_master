import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';
import 'TicketPurchaseScreen.dart';


class SectionsScreen extends StatefulWidget {
  final int departmentId;
  final String departmentName;

  const SectionsScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  List sections = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  Future<void> fetchSections() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final response = await ApiService.getWithToken('/visitor/sections/${widget.departmentId}', token);
    if (response != null && response.statusCode == 200) {
      setState(() {
        sections = response.data['sections'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحميل الأجنحة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أجنحة قسم ${widget.departmentName}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sections.isEmpty
          ? const Center(child: Text('لا توجد أجنحة في هذا القسم'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(section['name']),
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
    );
  }
}
