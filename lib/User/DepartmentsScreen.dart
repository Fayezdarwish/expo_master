// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'SectionsScreen.dart';
//
// class DepartmentScreen extends StatefulWidget {
//   const DepartmentScreen({super.key});
//
//   @override
//   State<DepartmentScreen> createState() => _DepartmentScreenState();
// }
//
// class _DepartmentScreenState extends State<DepartmentScreen>
//     with SingleTickerProviderStateMixin {
//   final List<Map<String, dynamic>> departments = [
//     {'id': 1, 'name': 'أغذية', 'icon': Icons.fastfood},
//     {'id': 2, 'name': 'إلكترونيات', 'icon': Icons.devices},
//     {'id': 3, 'name': 'جلود', 'icon': Icons.shopping_bag},
//     {'id': 4, 'name': 'أقمشة', 'icon': Icons.style},
//     {'id': 5, 'name': 'أثاث', 'icon': Icons.chair},
//     {'id': 6, 'name': 'ألعاب', 'icon': Icons.toys},
//     {'id': 7, 'name': 'عطور', 'icon': Icons.spa},
//     {'id': 8, 'name': 'كتب', 'icon': Icons.book},
//     {'id': 9, 'name': 'مفروشات', 'icon': Icons.bed},
//     {'id': 10, 'name': 'منتجات طبية', 'icon': Icons.medical_services},
//     {'id': 11, 'name': 'أدوات مكتبية', 'icon': Icons.create},
//     {'id': 12, 'name': 'معدات صناعية', 'icon': Icons.build},
//     {'id': 13, 'name': 'حرف يدوية', 'icon': Icons.handyman},
//     {'id': 14, 'name': 'معدات زراعية', 'icon': Icons.grass},
//     {'id': 15, 'name': 'مجوهرات', 'icon': Icons.diamond},
//   ];
//
//   late AnimationController _animationController;
//   late Animation<double> _shakeAnimation;
//   int? _shakingIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _shakeAnimation = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 0.0, end: 6.0), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
//       TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
//     ]).animate(_animationController);
//
//     _animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() => _shakingIndex = null);
//         _animationController.reset();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _saveSelectedDepartmentId(int id) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('selected_department_id', id);
//   }
//
//   void _onTapDepartment(int index, int id, String name) async {
//     setState(() => _shakingIndex = index);
//     _animationController.forward();
//     await Future.delayed(const Duration(milliseconds: 600));
//     await _saveSelectedDepartmentId(id);
//     if (!mounted) return;
//
//     // شرط خاص للإلكترونيات
//     if (id == 2) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => SectionsScreen(departmentId: id, departmentName: name),
//         ),
//       );
//     } else {
//       Navigator.pushNamed(context, '/exhibitor/submit-request', arguments: id);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(title: const Text('اختر القسم')),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: departments.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (context, index) {
//           final dept = departments[index];
//           return AnimatedBuilder(
//             animation: _shakeAnimation,
//             builder: (context, child) {
//               final offset = _shakingIndex == index ? _shakeAnimation.value : 0.0;
//               return Transform.translate(offset: Offset(offset, 0), child: child);
//             },
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.blue.withOpacity(0.2),
//                   child: Icon(dept['icon'], color: Colors.blue),
//                 ),
//                 title: Text(dept['name'], style: theme.textTheme.titleMedium),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
//                 onTap: () => _onTapDepartment(index, dept['id'], dept['name']),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// ✅ DepartmentScreen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SectionsScreen.dart';
import 'TicketPurchaseScreen.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> departments = [
    {'id': 1, 'name': 'أغذية', 'icon': Icons.fastfood},
    {'id': 2, 'name': 'إلكترونيات', 'icon': Icons.devices},
    {'id': 3, 'name': 'جلود', 'icon': Icons.shopping_bag},
    {'id': 4, 'name': 'أقمشة', 'icon': Icons.style},
    {'id': 5, 'name': 'أثاث', 'icon': Icons.chair},
    {'id': 6, 'name': 'ألعاب', 'icon': Icons.toys},
    {'id': 7, 'name': 'عطور', 'icon': Icons.spa},
    {'id': 8, 'name': 'كتب', 'icon': Icons.book},
    {'id': 9, 'name': 'مفروشات', 'icon': Icons.bed},
    {'id': 10, 'name': 'منتجات طبية', 'icon': Icons.medical_services},
    {'id': 11, 'name': 'أدوات مكتبية', 'icon': Icons.create},
    {'id': 12, 'name': 'معدات صناعية', 'icon': Icons.build},
    {'id': 13, 'name': 'حرف يدوية', 'icon': Icons.handyman},
    {'id': 14, 'name': 'معدات زراعية', 'icon': Icons.grass},
    {'id': 15, 'name': 'مجوهرات', 'icon': Icons.diamond},
  ];

  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  int? _shakingIndex;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
    ]).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _shakingIndex = null);
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveSelectedDepartmentId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_department_id', id);
  }

  void _onTapDepartment(int index, int id, String name) async {
    setState(() => _shakingIndex = index);
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    await _saveSelectedDepartmentId(id);
    if (!mounted) return;

    if (id == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TicketPreviewScreen(),
        ),
      );
    } else {
      Navigator.pushNamed(context, '/exhibitor/submit-request', arguments: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = departments
        .where((dept) => dept['name'].toString().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('اختر القسم')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن قسم...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final dept = filtered[index];
                return AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final offset = _shakingIndex == index ? _shakeAnimation.value : 0.0;
                    return Transform.translate(offset: Offset(offset, 0), child: child);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: Icon(dept['icon'], color: Colors.blue),
                      ),
                      title: Text(dept['name'], style: theme.textTheme.titleMedium),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
                      onTap: () => _onTapDepartment(index, dept['id'], dept['name']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}