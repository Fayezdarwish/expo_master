import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key});
  @override State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;

  @override void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.getWithToken('/exhibitor/requests', token!);
    if (res?.statusCode == 200) {
      final data = res!.data;
      _requests = List<Map<String, dynamic>>.from(
          data is Map ? data['requests'] : data
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات سابقة')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _requests.length,
          itemBuilder: (ctx, i) {
            final req = _requests[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(req['exhibitionName']),
                subtitle: Text('الحالة: ${req['status']}'),
                trailing: Text(
                    DateTime.parse(req['createdAt']).toLocal().toString().split(' ')[0]
                ),
                onTap: () => Navigator.pushNamed(
                    context, '/request-status',
                    arguments: req['id']
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
