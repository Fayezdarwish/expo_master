import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';
import 'BoothProductsScreen.dart';

class ReservedBoothsScreen extends StatefulWidget {
  final int departmentId;

  const ReservedBoothsScreen({super.key, required this.departmentId});

  @override
  State<ReservedBoothsScreen> createState() => _ReservedBoothsScreenState();
}

class _ReservedBoothsScreenState extends State<ReservedBoothsScreen> {
  List booths = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReservedBooths();
  }

  Future<void> fetchReservedBooths() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final response = await ApiService.getWithToken('/visitor/departments/${widget.departmentId}/reserved-booths', token);

    if (response != null && response.statusCode == 200) {
      setState(() {
        booths = response.data['booths'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحميل الأجنحة المحجوزة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأجنحة المحجوزة')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : booths.isEmpty
          ? const Center(child: Text('لا توجد أجنحة محجوزة'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: booths.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final booth = booths[index];
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(booth['name'], style: Theme.of(context).textTheme.titleLarge),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BoothProductsScreen(
                      boothId: booth['id'],
                      boothName: booth['name'],
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
