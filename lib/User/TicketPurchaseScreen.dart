import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';
import 'ReservedBoothsScreen.dart';


class TicketPurchaseScreen extends StatefulWidget {
  final int departmentId;
  final int sectionId;
  final String sectionName;

  const TicketPurchaseScreen({
    super.key,
    required this.departmentId,
    required this.sectionId,
    required this.sectionName,
  });

  @override
  State<TicketPurchaseScreen> createState() => _TicketPurchaseScreenState();
}

class _TicketPurchaseScreenState extends State<TicketPurchaseScreen> {
  bool isLoading = false;

  Future<void> buyTicket() async {
    setState(() => isLoading = true);

    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
      return;
    }

    final visitorData = {
      "visitorName": "اسم الزائر",
      "visitorEmail": "email@example.com",
      "departmentId": widget.departmentId,
    };

    final response = await ApiService.postWithToken('/visitor/buy-ticket', visitorData, token);

    setState(() => isLoading = false);

    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تم شراء التذكرة'),
          content: Text('لقد تم شراء التذكرة للقسم: ${widget.sectionName}'),
          actions: [
            TextButton(
              child: const Text('الأجنحة المحجوزة'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReservedBoothsScreen(departmentId: widget.departmentId),
                  ),
                );
              },
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل في شراء التذكرة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('شراء تذكرة - ${widget.sectionName}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'هل ترغب في شراء تذكرة للقسم "${widget.sectionName}"؟',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : buyTicket,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('شراء التذكرة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
