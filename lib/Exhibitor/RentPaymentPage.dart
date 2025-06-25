import 'package:flutter/material.dart';

class RentPaymentPage extends StatefulWidget {
  @override
  _RentPaymentPageState createState() => _RentPaymentPageState();
}

class _RentPaymentPageState extends State<RentPaymentPage> {
  bool isPaying = false;

  late int requestId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    requestId = ModalRoute.of(context)!.settings.arguments as int;
  }

  Future<void> payRent() async {
    setState(() {
      isPaying = true;
    });

    // استدعاء API للدفع - تحتاج إضافة دالة في VisitorApi

    // مثال:
    // final success = await VisitorApi.payRent(requestId);

    await Future.delayed(Duration(seconds: 2)); // محاكاة تأخير الدفع

    setState(() {
      isPaying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت عملية الدفع بنجاح')),
    );

    // يمكنك الرجوع للشاشة السابقة أو شاشة الطلب
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دفع الإيجار'),
      ),
      body: Center(
        child: isPaying
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: payRent,
          child: Text('دفع'),
        ),
      ),
    );
  }
}