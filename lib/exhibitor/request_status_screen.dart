import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({super.key});

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  Map<String, dynamic>? request;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatus();
  }

  void fetchStatus() async {
    final token = await TokenStorage.getToken();
    final req = await VisitorApi.getMyRequest(token!);
    setState(() {
      request = req;
      isLoading = false;
    });
  }

  void payNow() async {
    final token = await TokenStorage.getToken();
    final success = await VisitorApi.payForWing(token!);
    if (success) {
      Navigator.pushReplacementNamed(context, '/exhibitor/create_wing');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل الدفع')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (request == null) {
      return const Scaffold(
        body: Center(child: Text('لم يتم تقديم أي طلب بعد')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('حالة الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('القسم: ${request!['departmentName']}'),
            const SizedBox(height: 10),
            Text('الحالة: ${request!['status']}'),
            const SizedBox(height: 30),
            if (request!['status'] == 'تم القبول' && !request!['isPaid'])
              ElevatedButton(
                onPressed: payNow,
                child: const Text('دفع الرسوم وإنشاء الجناح'),
              ),
          ],
        ),
      ),
    );
  }
}
