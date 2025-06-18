import 'package:flutter/material.dart';
import '../api/BoothApi.dart';

class BoothPaymentScreen extends StatefulWidget {
  @override
  _BoothPaymentScreenState createState() => _BoothPaymentScreenState();
}

class _BoothPaymentScreenState extends State<BoothPaymentScreen> {
  bool isLoading = false;
  double amount = 100.0;
  String method = 'card';

  Future<void> pay() async {
    setState(() => isLoading = true);
    final success = await BoothApi.payForBooth(amount: amount, method: method);
    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم الدفع بنجاح')),
      );
      Navigator.pushReplacementNamed(context, '/booth-dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الدفع، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('دفع رسوم الجناح')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المبلغ المطلوب: \$${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('اختر طريقة الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('بطاقة ائتمان'),
              leading: Radio(value: 'card', groupValue: method, onChanged: (v) => setState(() => method = v!)),
            ),
            ListTile(
              title: Text('PayPal'),
              leading: Radio(value: 'paypal', groupValue: method, onChanged: (v) => setState(() => method = v!)),
            ),
            ListTile(
              title: Text('تحويل بنكي'),
              leading: Radio(value: 'bank', groupValue: method, onChanged: (v) => setState(() => method = v!)),
            ),
            SizedBox(height: 30),
            Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: pay,
                child: Text('ادفع الآن'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
