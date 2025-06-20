import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

/// شاشة لعرض حالة الطلبات للعارض (مقبولة، مرفوضة، قيد الانتظار)
class VendorRequestsStatusScreen extends StatefulWidget {
  @override
  _VendorRequestsStatusScreenState createState() => _VendorRequestsStatusScreenState();
}

class _VendorRequestsStatusScreenState extends State<VendorRequestsStatusScreen> {
  List requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  /// جلب طلبات العارض من السيرفر
  Future<void> fetchRequests() async {
    final token = await TokenStorage.getToken() ?? '';
    final response = await ApiService.getWithToken('/vendor/requests', token);
    if (response != null && response.statusCode == 200) {
      setState(() {
        requests = response.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('حالة طلباتك')),
      body: requests.isEmpty
          ? Center(child: Text('لا توجد طلبات حالياً'))
          : ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return ListTile(
            title: Text(req['section_name']),
            subtitle: Text('حالة الطلب: ${req['status']}'),
            trailing: req['status'] == 'مقبول'
                ? ElevatedButton(
              child: Text('ادفع الإيجار النهائي'),
              onPressed: () {
                Navigator.pushNamed(context, '/vendor_final_payment');
              },
            )
                : null,
          );
        },
      ),
    );
  }
}
