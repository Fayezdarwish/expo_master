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

class _SectionsScreenState extends State<SectionsScreen> with SingleTickerProviderStateMixin {
  List sections = [];
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchSections();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  Future<void> fetchSections() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    final response = await ApiService.getWithToken('/visitor/sections/${widget.departmentId}', token);
    if (response != null && response.statusCode == 200) {
      setState(() {
        sections = response.data['sections'];
        isLoading = false;
      });
      _animationController.forward();
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحميل الأجنحة')));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSectionItem(int index) {
    final section = sections[index];
    final animation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
      ),
    );

    final opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
      ),
    );

    return SlideTransition(
      position: animation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          child: ListTile(
            title: Text(section['name'], style: Theme.of(context).textTheme.titleLarge),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
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
        ),
      ),
    );
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
        itemBuilder: (_, index) => _buildSectionItem(index),
      ),
    );
  }
}
