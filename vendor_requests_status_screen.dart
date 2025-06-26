import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class VendorRequestsStatusScreen extends StatefulWidget {
  @override
  _VendorRequestsStatusScreenState createState() => _VendorRequestsStatusScreenState();
}

class _VendorRequestsStatusScreenState extends State<VendorRequestsStatusScreen> {
  List requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final token = await TokenStorage.getToken() ?? '';
    final response = await ApiService.getWithToken('/vendor/requests', token);
    if (response != null && response.statusCode == 200) {
      setState(() {
        requests = response.data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل جلب الطلبات')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('حالة طلباتك')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : requests.isEmpty
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
