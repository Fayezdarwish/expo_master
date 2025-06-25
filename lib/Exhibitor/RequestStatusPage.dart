import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class RequestStatusPage extends StatefulWidget {
  @override
  _RequestStatusPageState createState() => _RequestStatusPageState();
}

class _RequestStatusPageState extends State<RequestStatusPage> {
  late int requestId;
  Map<String, dynamic>? requestData;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    requestId = ModalRoute.of(context)!.settings.arguments as int;
    fetchRequestStatus();
  }

  Future<void> fetchRequestStatus() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      // خطأ في التوكن
      setState(() {
        isLoading = false;
        requestData = null;
      });
      return;
    }

    final data = await VisitorApi.getExhibitorRequestStatus(requestId, token);
    setState(() {
      requestData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = Center(child: CircularProgressIndicator());
    } else if (requestData == null) {
      content = Center(child: Text('لا توجد بيانات للطلب'));
    } else {
      final status = requestData!['status'] as String;
      final approval = status == 'approved';
      final rejectionReason = requestData!['rejectionReason'];

      content = Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('حالة الطلب:', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            Text(
              status == 'waiting-approval'
                  ? 'في انتظار موافقة مدير القسم'
                  : (status == 'approved' ? 'تمت الموافقة' : 'تم الرفض'),
              style: TextStyle(
                fontSize: 20,
                color: approval ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            if (status == 'rejected' && rejectionReason != null)
              Text('سبب الرفض: $rejectionReason', style: TextStyle(color: Colors.red)),
            SizedBox(height: 24),
            if (approval)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rentPayment', arguments: requestId);
                },
                child: Text('دفع الإيجار'),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('حالة الطلب')),
      body: content,
    );
  }
}
