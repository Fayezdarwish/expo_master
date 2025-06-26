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

class _BoothProductsScreenState extends State<BoothProductsScreen> with SingleTickerProviderStateMixin {
  List products = [];
  bool isLoading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fetchProducts();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );//
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
      _controller.forward();
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحميل المنتجات')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProductCard(Map product, int index) {
    final animation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut)),
    );

    return SlideTransition(
      position: animation,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          title: Text(
            product['name'],
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primaryContainer),
          ),
          subtitle: Text(
            product['description'] ?? 'بدون وصف',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${product['price']} د.ع',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          onTap: () {
            // ممكن تضيف حدث عند الضغط
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('منتجات ${widget.boothName}'),
        centerTitle: true,
        elevation: 10,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(
        child: Text(
          'لا توجد منتجات',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => _buildProductCard(products[index], index),
      ),
    );
  }
}
