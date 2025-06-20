// 👤 واجهة مدير القسم الرئيسية
import 'package:flutter/material.dart';

class SectionManagerDashboard extends StatelessWidget {
  const SectionManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة مدير القسم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/wings');
              },
              child: const Text('إدارة الأجنحة'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/requests');
              },
              child: const Text('طلبات العارضين'),
            ),
          ],
        ),
      ),
    );
  }
}

// 📋 واجهة قائمة الأجنحة
class WingsScreen extends StatelessWidget {
  final List<Map<String, String>> wings = [
    {"name": "جناح 1", "status": "مشغول", "area": "20م", "price": "1000\$"},
    {"name": "جناح 2", "status": "فارغ", "area": "25م", "price": "1200\$"},
  ];

  WingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأجنحة')),
      body: ListView.builder(
        itemCount: wings.length,
        itemBuilder: (context, index) {
          final wing = wings[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(wing['name']!),
              subtitle: Text('المساحة: ${wing['area']} | السعر: ${wing['price']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditWingScreen(wingData: wing),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // TODO: تنفيذ عملية الحذف
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateWingScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 🛠️ واجهة تعديل الجناح
class EditWingScreen extends StatelessWidget {
  final Map<String, String> wingData;

  const EditWingScreen({super.key, required this.wingData});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: wingData['name']);
    final areaController = TextEditingController(text: wingData['area']);
    final priceController = TextEditingController(text: wingData['price']);

    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الجناح')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم الجناح')),
            const SizedBox(height: 12),
            TextField(controller: areaController, decoration: const InputDecoration(labelText: 'المساحة')),
            const SizedBox(height: 12),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'السعر')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: تنفيذ عملية التعديل
              },
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }
}

// ➕ واجهة إنشاء جناح جديد
class CreateWingScreen extends StatelessWidget {
  const CreateWingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final areaController = TextEditingController();
    final priceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء جناح جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم الجناح')),
            const SizedBox(height: 12),
            TextField(controller: areaController, decoration: const InputDecoration(labelText: 'المساحة')),
            const SizedBox(height: 12),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'السعر')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: تنفيذ عملية الإضافة
              },
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }
}

// 📬 واجهة قائمة الطلبات
class RequestsScreen extends StatelessWidget {
  final List<Map<String, String>> requests = [
    {"name": "شركة ألف", "email": "a@ex.com", "status": "جديد"},
    {"name": "شركة باء", "email": "b@ex.com", "status": "قيد المعالجة"},
  ];

  RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات العارضين')),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(req['name']!),
              subtitle: Text(req['email']!),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RequestDetailsScreen(request: req),
                    ),
                  );
                },
                child: const Text('عرض'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🔍 واجهة تفاصيل الطلب + قبول أو رفض
class RequestDetailsScreen extends StatelessWidget {
  final Map<String, String> request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final rejectionReasonController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم العارض: ${request['name']}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('البريد الإلكتروني: ${request['email']}'),
            const SizedBox(height: 20),
            TextField(
              controller: rejectionReasonController,
              decoration: const InputDecoration(labelText: 'سبب الرفض (اختياري)'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: تنفيذ القبول
                    },
                    child: const Text('قبول'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: تنفيذ الرفض وإرسال سبب الرفض بالبريد
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('رفض'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
