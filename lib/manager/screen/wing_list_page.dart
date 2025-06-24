/// 2. wing_list_page.dart
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
  List<dynamic> wings = [];

  @override
  void initState() {
    super.initState();
    fetchWings();
  }

  Future<void> fetchWings() async {
    final response = await ApiService.get('/wings');
    if (response != null) {
      setState(() {
        wings = response.data;
      });
    }
  }

  Future<void> deleteWing(int id) async {
    await ApiService.deleteWithToken('/wings/$id', 'YOUR_TOKEN');
    fetchWings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الأجنحة')),
      body: ListView.builder(
        itemCount: wings.length,
        itemBuilder: (context, index) {
          final wing = wings[index];
          return ListTile(
            title: Text(wing['name']),
            subtitle: Text('معرف العارض: ${wing['participant_id']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditWingPage(wing: wing),
                    ),
                  ).then((_) => fetchWings()),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteWing(wing['id']),
                ),
              ],
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
      ),
    );
  }
}