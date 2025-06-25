import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class FinalPaymentScreen extends StatefulWidget {
  const FinalPaymentScreen({super.key});
  @override State<FinalPaymentScreen> createState() => _FinalPaymentScreenState();
}

class _FinalPaymentScreenState extends State<FinalPaymentScreen> {
  bool _isLoading = false;

  Future<void> _finishPayment() async {
    setState(() => _isLoading = true);
    final token = await TokenStorage.getToken();
    final res = await ApiService.postWithToken('/pay-final', {}, token!);
    setState(() => _isLoading = false);
    final msg = res?.statusCode == 200 ? 'تم الدفع النهائي!' : 'فشل الدفع';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    if (res?.statusCode == 200) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع النهائي')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('اضغط لإنهاء الدفع وإنشاء جناح'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _finishPayment,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('الدفع النهائي'),
            ),
          ],
        ),
      ),
    );
  }
}
 