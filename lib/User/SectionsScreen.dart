// import 'package:flutter/material.dart';
// import 'BoothProductsScreen.dart';
//
// class SectionsScreen extends StatelessWidget {
//   final int departmentId;
//   final String departmentName;
//
//   const SectionsScreen({
//     super.key,
//     required this.departmentId,
//     required this.departmentName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> dummySections = [
//       {'id': 101, 'name': 'ساعات'},
//
//     ];
//
//     return Scaffold(
//       appBar: AppBar(title: Text('أجنحة قسم $departmentName')),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: dummySections.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (_, index) {
//           final section = dummySections[index];
//           return Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: ListTile(
//               title: Text(section['name']),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => BoothProductsScreen(
//                       boothId: section['id'],
//                       boothName: section['name'],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// ✅ SectionsScreen.dart
import 'package:flutter/material.dart';
import 'BoothProductsScreen.dart';

class SectionsScreen extends StatelessWidget {
  final int departmentId;
  final String departmentName;

  const SectionsScreen({super.key, required this.departmentId, required this.departmentName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummySections = [
      {'id': 101, 'name': 'ساعات'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('أجنحة قسم $departmentName')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummySections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final section = dummySections[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(section['name']),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BoothProductsScreen(
                      boothId: section['id'],
                      boothName: section['name'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}