// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/token_storage.dart';
// import 'ReservedBoothsScreen.dart';
//
// class TicketPurchaseScreen extends StatefulWidget {
//   final int departmentId;
//   final int sectionId;
//   final String sectionName;
//
//   const TicketPurchaseScreen({
//     super.key,
//     required this.departmentId,
//     required this.sectionId,
//     required this.sectionName,
//   });
//
//   @override
//   State<TicketPurchaseScreen> createState() => _TicketPurchaseScreenState();
// }
//
// class _TicketPurchaseScreenState extends State<TicketPurchaseScreen> {
//   bool isLoading = false;
//   String? resultMessage;
//   bool ticketPurchased = false;
//
//   Future<void> purchaseTicket() async {
//     setState(() {
//       isLoading = true;
//       resultMessage = null;
//       ticketPurchased = false;
//     });
//
//     final token = await TokenStorage.getToken();
//     if (token == null) {
//       setState(() {
//         isLoading = false;
//         resultMessage = 'لم يتم العثور على توكن المستخدم';
//       });
//       return;
//     }
//
//     final response = await ApiService.postWithToken(
//       '/visitor/purchase-ticket',
//       {
//         'department_id': widget.departmentId,
//         'section_id': widget.sectionId,
//       },
//       token,
//     );
//
//     setState(() {
//       isLoading = false;
//       if (response != null && response.statusCode == 200) {
//         resultMessage = 'تم شراء التذكرة بنجاح!';
//         ticketPurchased = true;
//       } else {
//         resultMessage = 'فشل شراء التذكرة، حاول مرة أخرى.';
//       }
//     });
//   }
//
//   void goToReservedBooths() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ReservedBoothsScreen(departmentId: widget.departmentId),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('شراء تذكرة - ${widget.sectionName}')),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (resultMessage != null)
//                 Text(
//                   resultMessage!,
//                   style: TextStyle(
//                     color: resultMessage!.contains('نجاح') ? Colors.green : Colors.red,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: isLoading ? null : purchaseTicket,
//                 child: isLoading
//                     ? const SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                 )
//                     : const Text('شراء تذكرة'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(180, 50),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               if (ticketPurchased) ...[
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: goToReservedBooths,
//                   child: const Text('عرض الأجنحة المحجوزة'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(180, 50),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     backgroundColor: Colors.blueAccent,
//                   ),
//                 ),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ✅ TicketPreviewScreen.dart
import 'package:flutter/material.dart';
import 'SectionsScreen.dart';

class TicketPreviewScreen extends StatelessWidget {
  const TicketPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = 'fayez';
    final String email = 'fayez1@gmail.com';
    final String section = 'إلكترونيات';

    return Scaffold(
      appBar: AppBar(
        title: const Text('تذكرتك'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.confirmation_num, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'تذكرة دخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Divider(color: Colors.white54, thickness: 1.2, height: 30),
                ticketInfoRow('الاسم:', name),
                ticketInfoRow('البريد الإلكتروني:', email),
                ticketInfoRow('القسم المحجوز:', section),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SectionsScreen(
                          departmentId: 2,
                          departmentName: 'إلكترونيات',
                        ),
                      ),
                    );
                  },
                  child: const Text('موافق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ticketInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}