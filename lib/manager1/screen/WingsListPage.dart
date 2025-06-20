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

// 📬 قائمة الطلبات
class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  List requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.getWithToken('/exhibitor/requests', token!);
    if (res != null && res.statusCode == 200) {
      setState(() {
        requests = res.data['requests'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلبات العارضين')),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return ListTile(
            title: Text(req['company_name']),
            subtitle: Text('القسم: ${req['section_name']}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => RequestDetailsPage(request: req),
              )).then((_) => fetchRequests());
            },
          );
        },
      ),
    );
  }
}

// 📄 تفاصيل الطلب مع قبول/رفض
class RequestDetailsPage extends StatefulWidget {
  final Map request;
  const RequestDetailsPage({required this.request});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  final _reasonController = TextEditingController();

  void accept() async {
    final token = await TokenStorage.getToken();
    await ApiService.postWithToken('/requests/accept/${widget.request['id']}', {}, token!);
    Navigator.pop(context);
  }

  void reject() async {
    final token = await TokenStorage.getToken();
    await ApiService.postWithToken('/requests/reject/${widget.request['id']}', {
      'reason': _reasonController.text,
    }, token!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم التجاري: ${widget.request['company_name']}', style: Theme.of(context).textTheme.bodyMedium),
            Text('رقم الهاتف: ${widget.request['phone']}', style: Theme.of(context).textTheme.bodyMedium),
            Text('البريد الإلكتروني: ${widget.request['email']}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(labelText: 'سبب الرفض (إن وجد)'),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: accept, child: Text('قبول'))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: reject, child: Text('رفض'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
