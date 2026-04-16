import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_form_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final ProductViewModel viewModel;

  const ProductDetailPage({super.key, required this.product, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ProductFormPage(viewModel: viewModel, product: product),
            )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, color: Colors.white, padding: const EdgeInsets.all(24),
            child: Image.network(product.image, height: 260, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 120, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Chip(
                label: Text(product.category.toUpperCase()),
                backgroundColor: Colors.indigo.shade50,
                labelStyle: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.w600, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.indigo.shade600, borderRadius: BorderRadius.circular(12)),
                child: Text('USD ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const Text('Descrição', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                product.description.isEmpty ? 'Sem descrição disponível.' : product.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  icon: const Icon(Icons.home),
                  label: const Text('Voltar à tela inicial'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
