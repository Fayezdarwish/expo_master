// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
//
// class RequestsListPage extends StatefulWidget {
//   const RequestsListPage({super.key});
//
//   @override
//   State<RequestsListPage> createState() => _RequestsListPageState();
// }
//
// class _RequestsListPageState extends State<RequestsListPage> {
//   List<dynamic> requests = [];
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRequests();
//   }
//
//   Future<void> fetchRequests() async {
//     setState(() => isLoading = true);
//
//     final response = await ApiService.get('/requests');
//     if (response != null && response.statusCode == 200) {
//       final data = response.data;
//
//         setState(() {
//           requests = List.from(data);
//
//           // ✅ إضافة طلب افتراضي باسم Esraa
//           requests.insert(0, {
//             'id': -1,
//             'name': 'Esraa',
//             'email': 'e@gmail.com',
//             'booth': 'ساعات',
//           });
//         });
//
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   void handleAccept(Map<String, dynamic> request) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           request['id'] == -1
//               ? 'تم إضافة الجناح بنجاح'
//               : 'تم قبول الطلب (${request['name']})',
//         ),
//         backgroundColor: Colors.green,
//       ),
//     );
//     setState(() {
//       requests.remove(request);
//     });
//   }
//
//   void handleReject(Map<String, dynamic> request) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('تم رفض الطلب'),
//         backgroundColor: Colors.redAccent,
//       ),
//     );
//     setState(() {
//       requests.remove(request);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('طلبات العارضين')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requests.isEmpty
//           ? const Center(child: Text('لا توجد طلبات حالياً'))
//           : RefreshIndicator(
//         onRefresh: fetchRequests,
//         child: ListView.builder(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           itemCount: requests.length,
//           itemBuilder: (context, index) {
//             final req = requests[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       leading: const Icon(Icons.assignment_ind),
//                       title: Text(req['name']),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(req['email']),
//                           if (req['booth'] != null)
//                             Text('الجناح: ${req['booth']}'),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () => handleAccept(req),
//                           icon: const Icon(Icons.check),
//                           label: const Text('قبول'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton.icon(
//                           onPressed: () => handleReject(req),
//                           icon: const Icon(Icons.close),
//                           label: const Text('رفض'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class RequestsListPage extends StatefulWidget {
  const RequestsListPage({super.key});

  @override
  State<RequestsListPage> createState() => _RequestsListPageState();
}

class _RequestsListPageState extends State<RequestsListPage> {
  List<dynamic> requests = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // ✅ أولاً: أضف الطلب الوهمي مباشرة
    requests.add({
      'id': -1,
      'name': 'Esraa',
      'email': 'e@gmail.com',
      'booth': 'ساعات',
    });

    // ✅ ثم: ابدأ بجلب الطلبات الحقيقية
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() => isLoading = true);

    final response = await ApiService.get('/requests');
    if (response != null && response.statusCode == 200) {
      final data = response.data;
      if (data is List) {
        setState(() {
          requests.addAll(data); // أضف الطلبات الحقيقية تحت الطلب الافتراضي
        });
      }
    }

    setState(() => isLoading = false);
  }

  void handleAccept(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          request['id'] == -1
              ? 'تم إضافة الجناح بنجاح'
              : 'تم قبول الطلب (${request['name']})',
        ),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      requests.remove(request);
    });
  }

  void handleReject(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم رفض الطلب'),
        backgroundColor: Colors.redAccent,
      ),
    );
    setState(() {
      requests.remove(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات العارضين')),
      body: isLoading && requests.length <= 1 // فقط Esraa موجودة
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text('لا توجد طلبات حالياً'))
          : RefreshIndicator(
        onRefresh: fetchRequests,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.assignment_ind),
                      title: Text(req['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(req['email']),
                          if (req['booth'] != null)
                            Text('الجناح: ${req['booth']}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => handleAccept(req),
                          icon: const Icon(Icons.check),
                          label: const Text('قبول'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => handleReject(req),
                          icon: const Icon(Icons.close),
                          label: const Text('رفض'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
