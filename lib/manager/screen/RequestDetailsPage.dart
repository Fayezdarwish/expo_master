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
  bool isProcessing = false;

  Future<void> acceptRequest() async {
    setState(() => isProcessing = true);
    try {
      await ApiService.postWithToken(
        '/requests/${widget.request['id']}/accept',
        {},
        'YOUR_TOKEN',
      );

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء قبول الطلب')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  Future<void> rejectRequest() async {
    final reason = reasonController.text.trim();
    setState(() => isProcessing = true);

    try {
      await ApiService.postWithToken(
        '/requests/${widget.request['id']}/reject',
        {'reason': reason},
        'YOUR_TOKEN',
      );

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء رفض الطلب')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isProcessing
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الجناح الوهمي: ساعات
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.watch,
                      color: Colors.blueAccent),
                  title: const Text(
                    'جناح: ساعات',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: const Text('اسم العارض: Esraa'),
                  tileColor: const Color(0xFFEAF3FF),
                ),
              ),
              const SizedBox(height: 16),

              // معلومات المستخدم
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(req['name']),
                  subtitle: Text(req['email']),
                ),
              ),
              const SizedBox(height: 20),

              // سبب الرفض
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'سبب الرفض (اختياري)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // أزرار القبول والرفض
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('قبول'),
                      onPressed: acceptRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('رفض'),
                      onPressed: rejectRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
