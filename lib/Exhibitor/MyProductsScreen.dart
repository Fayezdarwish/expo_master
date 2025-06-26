import 'package:flutter/material.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية
    final products = [
      {'name': 'منتج 1', 'price': '100'},
      {'name': 'منتج 2', 'price': '200'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('منتجاتي')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']!),
            subtitle: Text('السعر: ${product['price']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
              ],
            ),
          );
        },
      ),
    );
  }
}
