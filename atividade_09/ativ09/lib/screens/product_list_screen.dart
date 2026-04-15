import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _State();
}

class _State extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ProductProvider>().fetchProducts());
  }

  Future<void> _delete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto?'),
        content: Text('"${p.title}"'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<ProductProvider>().deleteProduct(p.id!);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto excluído.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<ProductProvider>().fetchProducts())],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductFormScreen())),
        icon: const Icon(Icons.add), label: const Text('Novo'), backgroundColor: Colors.indigo, foregroundColor: Colors.white,
      ),
      body: Consumer<ProductProvider>(
        builder: (_, p, __) {
          if (p.isLoading) return const Center(child: CircularProgressIndicator());
          if (p.error != null) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.red),
            const SizedBox(height: 8),
            Text(p.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.read<ProductProvider>().fetchProducts(), child: const Text('Tentar novamente')),
          ]));
          if (p.products.isEmpty) return const Center(child: Text('Nenhum produto.'));

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: p.products.length,
            itemBuilder: (_, i) {
              final prod = p.products[i];
              return Dismissible(
                key: ValueKey(prod.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async { await _delete(prod); return false; },
                background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(prod.image, width: 50, height: 50, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey)),
                    ),
                    title: Text(prod.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: Text('USD ${prod.price.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.indigo), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductFormScreen(product: prod)))),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _delete(prod)),
                    ]),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: prod))),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
