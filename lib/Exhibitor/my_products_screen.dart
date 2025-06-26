import 'package:flutter/material.dart';
import '../../../services/token_storage.dart';
import '../../../services/api_service.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  Future<void> fetchProducts() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      // handle no token case
      setState(() => isLoading = false);
      return;
    }
    final response = await ApiService.getWithToken('/products/my', token);

    if (response != null && response.statusCode == 200) {
      setState(() {
        products = List<Map<String, dynamic>>.from(response.data['products']);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      // handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب المنتجات')),
      );
    }
  }

  Future<void> deleteProduct(int id) async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final response = await ApiService.deleteWithToken('/products/$id', token);
    if (response?.statusCode == 200) {
      fetchProducts();
    } else {
      // handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في حذف المنتج')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منتجاتي')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name'] ?? ''),
            subtitle: Text(product['description'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/exhibitor/edit-product',
                      arguments: product,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteProduct(product['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
