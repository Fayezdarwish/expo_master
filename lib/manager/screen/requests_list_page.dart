import 'package:flutter/material.dart';
import 'RequestDetailsPage.dart';
import '../../services/api_service.dart';

class RequestsListPage extends StatefulWidget {
  const RequestsListPage({super.key});

  @override
  State<RequestsListPage> createState() => _RequestsListPageState();
}

class _RequestsListPageState extends State<RequestsListPage> {
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    // هنا نستخدم ApiService.get الذي يعيد Response وليس البيانات مباشرة
    final response = await ApiService.get('/requests');

    // نتأكد أن الرد غير فارغ ورمز الحالة 200
    if (response != null && response.statusCode == 200) {
      final data = response.data;

      // نتأكد أن البيانات هي List قبل تعيينها للحالة
      if (data is List) {
        setState(() {
          requests = data;
        });
      } else {
        debugPrint('البيانات غير متوقعة: $data');
      }
    } else {
      debugPrint('فشل في جلب البيانات أو استجابة غير 200');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات')),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return ListTile(
            title: Text('طلب من: ${req['name']}'),
            subtitle: Text('البريد: ${req['email']}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RequestDetailsPage(request: req),
              ),
            ),
          );
        },
      ),
    );
  }
}
