import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';


class BoothProductsScreen extends StatefulWidget {
  final int boothId;
  final String boothName;

  const BoothProductsScreen({
    super.key,
    required this.boothId,
    required this.boothName,
  });

  @override
  State<BoothProductsScreen> createState() => _BoothProductsScreenState();
}

class _BoothProductsScreenState extends State<BoothProductsScreen> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final response = await ApiService.getWithToken('/visitor/products/${widget.boothId}', token);
    if (response != null && response.statusCode == 200) {
      setState(() {
        products = response.data['products'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحميل المنتجات')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('منتجات ${widget.boothName}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('لا توجد منتجات'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text(product['description'] ?? ''),
              trailing: Text('${product['price']} د.ع'),
            ),
          );
        },
      ),
    );
  }
}
