import 'package:flutter/material.dart';

/// شاشة الدفع الأولى (دفع الرسوم الابتدائية لتثبيت الطلب)
class VendorInitialPaymentScreen extends StatelessWidget {
  /// محاكاة إتمام الدفع
  void completePayment(BuildContext context) {
    // هنا نضع منطق الدفع التجريبي
    // بعد الدفع ننتقل لشاشة انتظار الرد أو دفع الإيجار
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
