import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';


// واجهة مدير القسم الرئيسية
class SectionManagerHome extends StatelessWidget {
  const SectionManagerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة مدير القسم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WingListPage()),
              ),
              child: const Text('إدارة الأجنحة'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RequestsListPage()),
              ),
              child: const Text('الطلبات'),
            ),
          ],
        ),
      ),
    );
  }
}

// واجهة عرض الأجنحة
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

// واجهة تعديل جناح
class EditWingPage extends StatelessWidget {
  const EditWingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: "اسم الجناح الحالي");
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الجناح')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم الجناح'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // تعديل الجناح عبر API
              },
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }
}

// واجهة إضافة جناح جديد
class AddWingPage extends StatelessWidget {
  const AddWingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة جناح')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم الجناح'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final token = await TokenStorage.getToken();
                if (token != null) {
                  await ApiService.postWithToken('/wings', {
                    'name': nameController.text,
                  }, token);
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }
}

// واجهة عرض الطلبات
class RequestsListPage extends StatelessWidget {
  const RequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات')),
      body: ListView.builder(
        itemCount: 5, // مؤقتاً
        itemBuilder: (context, index) => ListTile(
          title: Text('طلب ${index + 1}'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RequestDetailsPage()),
          ),
        ),
      ),
    );
  }
}

// تفاصيل الطلب مع القبول والرفض
class RequestDetailsPage extends StatefulWidget {
  const RequestDetailsPage({super.key});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تفاصيل العارض ... (مؤقت)'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'سبب الرفض (في حال الرفض)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // قبول الطلب
                      // await ApiService.postWithToken(...)
                    },
                    child: const Text('قبول'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // رفض الطلب
                      // await ApiService.postWithToken(...)
                    },
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
