// wing_list_page.dart
import 'package:flutter/material.dart';
import 'edit_wing_page.dart';
import 'add_wing_page.dart';

/// واجهة عرض الأجنحة
class WingListPage extends StatelessWidget {
  const WingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الأجنحة')),
      body: ListView.builder(
        itemCount: 5, // عدد الأجنحة (مؤقتًا)
        itemBuilder: (context, index) => ListTile(
          title: Text('جناح ${index + 1}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditWingPage()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // حذف الجناح من خلال API لاحقاً
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddWingPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
