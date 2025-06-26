import 'package:flutter/material.dart';

class VendorInitialPaymentScreen extends StatelessWidget {
  /// محاكاة إتمام الدفع
  void completePayment(BuildContext context) {
    // بعد الدفع ننتقل لشاشة حالة الطلب أو دفع الإيجار النهائي
    Navigator.pushReplacementNamed(context, '/vendor_request_status');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('دفع الرسوم الابتدائية')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('يرجى دفع الرسوم الابتدائية لتثبيت طلبك', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => completePayment(context),
              child: Text('دفع الآن (تجريبي)'),
            ),
          ],
        ),
      ),
    );
  }
}
