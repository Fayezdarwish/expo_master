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
  String? resultMessage;
  bool ticketPurchased = false;

  Future<void> purchaseTicket() async {
    setState(() {
      isLoading = true;
      resultMessage = null;
      ticketPurchased = false;
    });

    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() {
        isLoading = false;
        resultMessage = 'لم يتم العثور على توكن المستخدم';
      });
      return;
    }

    final response = await ApiService.postWithToken(
      '/visitor/purchase-ticket',
      {
        'department_id': widget.departmentId,
        'section_id': widget.sectionId,
      },
      token,
    );

    setState(() {
      isLoading = false;
      if (response != null && response.statusCode == 200) {
        resultMessage = 'تم شراء التذكرة بنجاح!';
        ticketPurchased = true;
      } else {
        resultMessage = 'فشل شراء التذكرة، حاول مرة أخرى.';
      }
    });
  }

  void goToReservedBooths() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReservedBoothsScreen(departmentId: widget.departmentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('شراء تذكرة - ${widget.sectionName}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (resultMessage != null)
                Text(
                  resultMessage!,
                  style: TextStyle(
                    color: resultMessage!.contains('نجاح') ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : purchaseTicket,
                child: isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
                    : const Text('شراء تذكرة'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (ticketPurchased) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: goToReservedBooths,
                  child: const Text('عرض الأجنحة المحجوزة'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(180, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
