import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_state.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductPage extends StatefulWidget {
  final ProductViewModel viewModel;
  const ProductPage({super.key, required this.viewModel});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: widget.viewModel.loadProducts)],
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: widget.viewModel.loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ]));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.products.length,
            itemBuilder: (context, index) => _ProductCard(product: state.products[index]),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(product.image, width: 80, height: 80, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(20)),
              child: Text(product.category, style: TextStyle(fontSize: 11, color: Colors.indigo.shade700)),
            ),
            const SizedBox(height: 6),
            Text('USD ${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
          ])),
        ]),
      ),
    );
  }
}
