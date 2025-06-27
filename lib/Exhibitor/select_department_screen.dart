import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectDepartmentScreen extends StatefulWidget {
  const SelectDepartmentScreen({super.key});

  @override
  State<SelectDepartmentScreen> createState() => _SelectDepartmentScreenState();
}

class _SelectDepartmentScreenState extends State<SelectDepartmentScreen>
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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 8.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 8.0, end: -8.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -8.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 1,
      ),
    ]).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _shakingIndex = null;
        });
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

  void _onTapDepartment(int index, int id) async {
    setState(() => _shakingIndex = index);
    _animationController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    await _saveSelectedDepartmentId(id);
    if (!mounted) return;
    Navigator.pushNamed(context, '/exhibitor/submit-request', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('اختر القسم'),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: departments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final department = departments[index];
          final isShaking = _shakingIndex == index;

          return AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              final offsetX = isShaking ? _shakeAnimation.value : 0.0;
              return Transform.translate(
                offset: Offset(offsetX, 0),
                child: child,
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
              shadowColor: Colors.blue.shade100,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF4A90E2).withOpacity(0.2),
                  child: Icon(
                    department['icon'],
                    color: const Color(0xFF4A90E2),
                    size: 26,
                  ),
                ),
                title: Text(
                  department['name'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Color(0xFF4A90E2)),
                onTap: () => _onTapDepartment(index, department['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
