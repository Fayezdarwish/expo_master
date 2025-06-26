import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class RequestDetailsPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const RequestDetailsPage({super.key, required this.request});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  final TextEditingController reasonController = TextEditingController();

  Future<void> acceptRequest() async {
    await ApiService.postWithToken(
      '/requests/${widget.request['id']}/accept',
      {},
      'YOUR_TOKEN', // بدّلها بالتوكن
    );

    // إذا عندك API لإرسال الإيميل
    // await ApiService.sendEmail(
    //   widget.request['email'],
    //   'تم قبول طلبك. يرجى إتمام الدفعة النهائية.',
    // );

    Navigator.pop(context);
  }

  Future<void> rejectRequest() async {
    final reason = reasonController.text;

    await ApiService.postWithToken(
      '/requests/${widget.request['id']}/reject',
      {'reason': reason},
      'YOUR_TOKEN',
    );

    // إذا عندك API لإرسال الإيميل
    // await ApiService.sendEmail(
    //   widget.request['email'],
    //   'نأسف، تم رفض طلبك. السبب: $reason',
    // );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: ${req['name']}'),
            Text('البريد: ${req['email']}'),
            const SizedBox(height: 20),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'سبب الرفض (اختياري)',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: acceptRequest,
                    child: const Text('قبول'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: rejectRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('رفض'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
