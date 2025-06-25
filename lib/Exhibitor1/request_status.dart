import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class RequestStatusScreen extends StatefulWidget {
  final int requestId;
  const RequestStatusScreen({super.key, required this.requestId});

  @override State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  Map<String, dynamic>? _statusData;
  bool _isLoading = true;

  @override void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    setState(() => _isLoading = true);
    final token = await TokenStorage.getToken();
    final res = await ApiService.getWithToken('/track-request', token!);
    if (res?.statusCode == 200) {
      setState(() => _statusData = res!.data);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _payInitial() async {
    setState(() => _isLoading = true);
    final token = await TokenStorage.getToken();
    await ApiService.postWithToken('/pay-initial', {}, token!);
    await _fetchStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حالة الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading || _statusData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('الحالة: ${_statusData!['status']}'),
          Text('الدفعة الأولى: ${_statusData!['paymentStatus']}'),
          Text('الدفعة النهائية: ${_statusData!['finalPaymentStatus']}'),
          Text('تم تحديد جناح: ${_statusData!['wingAssigned']}'),
          const SizedBox(height: 20),
          if (_statusData!['status'] == 'approved' && _statusData!['paymentStatus'] == 'unpaid')
            ElevatedButton(onPressed: _payInitial, child: const Text('دفع الإيجار')),
        ]),
      ),
    );
  }
}
