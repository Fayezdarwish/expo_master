// ✅ BoothProductsScreen.dart
import 'package:flutter/material.dart';

class BoothProductsScreen extends StatelessWidget {
  final int boothId;
  final String boothName;

  const BoothProductsScreen({
    super.key,
    required this.boothId,
    required this.boothName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyProducts = boothName == 'ساعات'
        ? [
      {
        'name': 'ساعة ذكية',
        'description': 'ساعة ذكية بمميزات متعددة مع شاشة لمس.',
        'price': 150.0,
        'icon': Icons.watch,
      },
    ]
        : [];

    return Scaffold(
      appBar: AppBar(title: Text('منتجات $boothName')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyProducts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: Icon(product['icon'], color: boothName == 'ساعات' ? Colors.blue : Colors.grey),
              title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(product['description']),
              trailing: Text('${product['price']} ر.س', style: const TextStyle(color: Colors.green)),
            ),
          );
        },
      ),
    );
  }
}