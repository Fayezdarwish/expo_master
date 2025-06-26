import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VendorFinalPaymentScreen extends StatelessWidget {
  final int requestId; // رقم طلب العارض

  VendorFinalPaymentScreen({required this.requestId});

  void completeFinalPayment(BuildContext context) async {
    final data = {
      "finalPaymentStatus": "paid",
      "finalPaymentDate": DateTime.now().toIso8601String(),
    };

    final response = await ApiService.post('/pay-final', data);

    if (response != null && response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إتمام الدفع النهائي بنجاح')));
      Navigator.pushReplacementNamed(context, '/vendor_create_booth');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الدفع النهائي')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('دفع إيجار القسم')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'يرجى دفع إيجار القسم كاملاً لإتمام إنشاء الجناح',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => completeFinalPayment(context),
              child: Text('دفع الإيجار (تجريبي)'),
            ),
          ],
        ),
      ),
    );
  }
}
