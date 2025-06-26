  // ✅ PaymentScreen.dart
  import 'package:flutter/material.dart';

  class PaymentScreen extends StatelessWidget {
    const PaymentScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

      void _payAndNavigate() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت عملية الدفع بنجاح'), backgroundColor: Colors.green),
        );

        Future.delayed(const Duration(milliseconds: 600), () {
          Navigator.pushNamed(
            context,
            '/exhibitor/create-wing',
            arguments: args, // إعادة تمرير كل البيانات
          );
        });
      }

      return Scaffold(
        appBar: AppBar(title: const Text('دفع الدفعة النهائية')),
        body: Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.payment),
            label: const Text('دفع الآن'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: _payAndNavigate,
          ),
        ),
      );
    }
  }

