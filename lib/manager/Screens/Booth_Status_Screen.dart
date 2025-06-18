import 'package:flutter/material.dart';
import '../api/BoothApi.dart';

class BoothStatusScreen extends StatefulWidget {
  @override
  _BoothStatusScreenState createState() => _BoothStatusScreenState();
}

class _BoothStatusScreenState extends State<BoothStatusScreen> {
  Map<String, dynamic>? request;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequest();
  }

  Future<void> loadRequest() async {
    final res = await BoothApi.getMyBookingRequest();
    setState(() {
      request = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('حالة الجناح')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : request == null
          ? Center(child: Text('لم يتم العثور على طلب جناح.'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الشركة: ${request!['company_name'] ?? 'غير محدد'}', style: TextStyle(fontSize: 16)),
            Text('القسم: ${request!['department_name'] ?? 'غير محدد'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            _buildStatusWidget(request!['status'], request!['rejectionReason']),
            Spacer(),
            if (request!['status'] == 'Rejected')
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit-booth-request');
                  },
                  child: Text('تعديل الطلب'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusWidget(String status, String? reason) {
    Color color;
    String message;

    switch (status) {
      case 'Review':
        color = Colors.amber;
        message = 'قيد المراجعة';
        break;
      case 'Accepted':
        color = Colors.green;
        message = 'تم القبول';
        break;
      case 'Rejected':
        color = Colors.red;
        message = 'تم الرفض: ${reason ?? 'لا يوجد سبب محدد'}';
        break;
      default:
        color = Colors.grey;
        message = 'غير معروف';
    }

    return Row(
      children: [
        Icon(Icons.info, color: color),
        SizedBox(width: 8),
        Text(message, style: TextStyle(color: color, fontSize: 16)),
      ],
    );
  }
}
