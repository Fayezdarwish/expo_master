import 'package:flutter/material.dart';

/// شاشة دفع الإيجار النهائي بعد قبول الطلب
class VendorFinalPaymentScreen extends StatelessWidget {
  /// محاكاة إتمام الدفع النهائي
  void completeFinalPayment(BuildContext context) {
    // بعد الدفع النهائي، ننتقل لشاشة إنشاء الجناح
    Navigator.pushReplacementNamed(context, '/vendor_create_booth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('دفع إيجار القسم')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('يرجى دفع إيجار القسم كاملاً لإتمام إنشاء الجناح', style: Theme.of(context).textTheme.bodyMedium),
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
