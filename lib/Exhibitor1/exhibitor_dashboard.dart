import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../../services/api_service.dart';

class ExhibitorDashboard extends StatefulWidget {
  const ExhibitorDashboard({super.key});
  @override State<ExhibitorDashboard> createState() => _ExhibitorDashboardState();
}

class _ExhibitorDashboardState extends State<ExhibitorDashboard> {
  Map<String, dynamic>? _latestRequest;
  bool _isLoading = true;

  @override void initState() {
    super.initState();
    _loadLatestRequest();
  }

  Future<void> _loadLatestRequest() async {
    setState(() => _isLoading = true);
    final token = await TokenStorage.getToken();
    if (token == null) return;
    final res = await ApiService.getWithToken('/exhibitor/requests', token);
    if (res?.statusCode == 200) {
      List requests = res!.data is Map ? res.data['requests'] : res.data;
      if (requests.isNotEmpty) _latestRequest = requests.last;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة العارض')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _latestRequest == null
            ? Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/request-form'),
            child: const Text('تقديم طلب جديد'),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('أحدث طلب:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الحالة: ${_latestRequest!['status']}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context, '/request-status',
                        arguments: _latestRequest!['id'],
                      ),
                      child: const Text('عرض التفاصيل'),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/request-history'),
              child: const Text('طلباتي السابقة'),
            ),
          ],
        ),
      ),
    );
  }
}
