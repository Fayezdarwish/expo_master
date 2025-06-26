/// 3. requests_list_page.dart (بدون تعديل كبير، لكن متناسق)
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'RequestDetailsPage.dart';


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
    final response = await ApiService.get('/requests');
    if (response != null && response.statusCode == 200) {
      final data = response.data;
      if (data is List) {
        setState(() {
          requests = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات العارضين')),
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
            ).then((_) => fetchRequests()),
          );
        },
      ),
    );
  }
}
