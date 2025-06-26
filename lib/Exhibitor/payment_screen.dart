import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  void _payAndNavigate(BuildContext context) async {
    // هنا مكان تنفيذ عملية الدفع عبر API

    // بعد نجاح الدفع:
    Navigator.pushNamed(context, '/exhibitor/create-wing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دفع الدفعة النهائية')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.payment),
          label: const Text('دفع الآن'),
          onPressed: () => _payAndNavigate(context),
        ),
      ),
    );
  }
}
