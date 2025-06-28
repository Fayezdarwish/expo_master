// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import 'add_wing_page.dart';
// import 'edit_wing_page.dart';
//
// class WingListPage extends StatefulWidget {
//   const WingListPage({super.key});
//
//   @override
//   State<WingListPage> createState() => _WingListPageState();
// }
//
// class _WingListPageState extends State<WingListPage> {
//   List<dynamic> wings = [];
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWings();
//   }
//
//   Future<void> fetchWings() async {
//     setState(() => isLoading = true);
//     final response = await ApiService.get('/wings');
//     if (response != null && response.statusCode == 200) {
//       setState(() {
//         wings = response.data;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('فشل تحميل الأجنحة')),
//       );
//     }
//     setState(() => isLoading = false);
//   }
//
//   Future<void> deleteWing(int id) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: const Text('هل أنت متأكد من حذف هذا الجناح؟'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
//         ],
//       ),
//     );
//
//     if (confirmed == true) {
//       await ApiService.deleteWithToken('/wings/$id', 'YOUR_TOKEN');
//       fetchWings();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('قائمة الأجنحة')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : wings.isEmpty
//           ? const Center(child: Text('لا توجد أجنحة حالياً'))
//           : ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         itemCount: wings.length,
//         itemBuilder: (context, index) {
//           final wing = wings[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 3,
//             child: ListTile(
//               title: Text(wing['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Text('معرف العارض: ${wing['participant_id']}'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => EditWingPage(wing: wing),
//                       ),
//                     ).then((_) => fetchWings()),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.redAccent),
//                     onPressed: () => deleteWing(wing['id']),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddWingPage()),
//         ).then((_) => fetchWings()),
//         child: const Icon(Icons.add),
//         tooltip: 'إضافة جناح جديد',
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_wing_page.dart';
import 'edit_wing_page.dart';

class WingListPage extends StatefulWidget {
  const WingListPage({super.key});

  @override
  State<WingListPage> createState() => _WingListPageState();
}

class _WingListPageState extends State<WingListPage> {
  List<Map<String, dynamic>> wings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // ✅ إضافة جناح افتراضي فوري
    wings.add({
      'id': -1,
      'name': 'ساعات',
      'participant_id': 'esraa',
      'isVirtual': true,
    });

    fetchWings();
  }

  Future<void> fetchWings() async {
    setState(() => isLoading = true);
    final response = await ApiService.get('/wings');
    if (response != null && response.statusCode == 200) {
      setState(() {
        final realWings = List<Map<String, dynamic>>.from(response.data);
        wings.addAll(realWings);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تحميل الأجنحة')),
      );
    }
    setState(() => isLoading = false);
  }

  void acceptVirtualWing(Map<String, dynamic> wing) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة الجناح بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      wings.remove(wing);
    });
  }

  Future<void> deleteWing(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الجناح؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService.deleteWithToken('/wings/$id', 'YOUR_TOKEN');
      fetchWings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الأجنحة')),
      body: isLoading && wings.length <= 1
          ? const Center(child: CircularProgressIndicator())
          : wings.isEmpty
          ? const Center(child: Text('لا توجد أجنحة حالياً'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: wings.length,
        itemBuilder: (context, index) {
          final wing = wings[index];
          final isVirtual = wing['isVirtual'] == true;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              title: Text(
                wing['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('معرف العارض: ${wing['participant_id']}'),
              trailing: isVirtual
                  ? ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('قبول'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () => acceptVirtualWing(wing),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditWingPage(wing: wing),
                      ),
                    ).then((_) => fetchWings()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => deleteWing(wing['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddWingPage()),
        ).then((_) => fetchWings()),
        child: const Icon(Icons.add),
        tooltip: 'إضافة جناح جديد',
      ),
    );
  }
}
