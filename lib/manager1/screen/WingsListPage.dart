// 🧱 قائمة الأجنحة (مع زر الإضافة)
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';


class WingsListPage extends StatefulWidget {
  final int sectionId;
  const WingsListPage({required this.sectionId});

  @override
  _WingsListPageState createState() => _WingsListPageState();
}

class _WingsListPageState extends State<WingsListPage> {
  List wings = [];

  @override
  void initState() {
    super.initState();
    fetchWings();
  }

  Future<void> fetchWings() async {
    final token = await TokenStorage.getToken();
    final response = await ApiService.getWithToken('/wings/section/${widget.sectionId}', token!);
    if (response != null && response.statusCode == 200) {
      setState(() {
        wings = response.data['wings'];
      });
    }
  }

  void deleteWing(int wingId) async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.deleteWithToken('/wings/$wingId', token!);
    if (res != null && res.statusCode == 200) {
      fetchWings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة الأجنحة')),
      body: ListView.builder(
        itemCount: wings.length,
        itemBuilder: (context, index) {
          final wing = wings[index];
          return ListTile(
            title: Text(wing['name'], style: Theme.of(context).textTheme.bodyMedium),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => EditWingPage(wingId: wing['id'], initialName: wing['name']),
                    )).then((_) => fetchWings());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteWing(wing['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => AddWingPage(sectionId: widget.sectionId),
          )).then((_) => fetchWings());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// 🛠️ تعديل جناح
class EditWingPage extends StatefulWidget {
  final int wingId;
  final String initialName;
  const EditWingPage({required this.wingId, required this.initialName});

  @override
  _EditWingPageState createState() => _EditWingPageState();
}

class _EditWingPageState extends State<EditWingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  void updateWing() async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.putWithToken('/wings/${widget.wingId}', {
      'name': _nameController.text,
    }, token!);
    if (res != null && res.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تعديل الجناح')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'اسم الجناح'),
                validator: (value) => value!.isEmpty ? 'أدخل الاسم' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: updateWing, child: Text('حفظ')),
            ],
          ),
        ),
      ),
    );
  }
}

// ➕ إضافة جناح جديد
class AddWingPage extends StatefulWidget {
  final int sectionId;
  const AddWingPage({required this.sectionId});

  @override
  _AddWingPageState createState() => _AddWingPageState();
}

class _AddWingPageState extends State<AddWingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  void addWing() async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.postWithToken('/wings', {
      'name': _nameController.text,
      'section_id': widget.sectionId
    }, token!);
    if (res != null && res.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة جناح')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'اسم الجناح'),
                validator: (value) => value!.isEmpty ? 'أدخل الاسم' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: addWing, child: Text('إضافة')),
            ],
          ),
        ),
      ),
    );
  }
}
