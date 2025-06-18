import 'package:flutter/material.dart';
import '../api/ProductsApi.dart';
import '../api/BoothApi.dart';

class BoothDashboardScreen extends StatefulWidget {
  @override
  _BoothDashboardScreenState createState() => _BoothDashboardScreenState();
}

class _BoothDashboardScreenState extends State<BoothDashboardScreen> {
  Map<String, dynamic>? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => isLoading = true);
    final data = await BoothApi.getBoothStats();
    setState(() {
      stats = data;
      isLoading = false;
    });
  }

  Future<void> deleteProduct(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذا المنتج؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('حذف')),
        ],
      ),
    );
    if (confirmed == true) {
      final ok = await BoothApi.deleteProduct(id);
      if (ok) loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لوحة التحكم')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : stats == null
          ? Center(child: Text('فشل في تحميل البيانات'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatBox('المنتجات', stats!['productsCount']),
                _buildStatBox('الطلبات', stats!['ordersCount']),
                _buildStatBox('التقييمات', stats!['commentsCount']),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/add-product'),
              icon: Icon(Icons.add),
              label: Text('إضافة منتج'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: (stats!['products'] as List).length,
                itemBuilder: (_, i) {
                  final prod = stats!['products'][i];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: prod['image_url'] != null
                          ? Image.network(prod['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.image_not_supported),
                      title: Text(prod['name']),
                      subtitle: Text('السعر: ${prod['price']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.pushNamed(context, '/edit-product', arguments: prod);
                          } else if (value == 'delete') {
                            deleteProduct(prod['id']);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'edit', child: Text('تعديل')),
                          PopupMenuItem(value: 'delete', child: Text('حذف')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-booth'),
              child: Text('تعديل بيانات الجناح'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/view-booth'),
              child: Text('عرض الجناح'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, int count) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 4),
        Text('$count', style: TextStyle(fontSize: 20, color: Colors.blue)),
      ],
    );
  }
}
