import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_state.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

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

  Future<void> _confirmDelete(Product product) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto?'),
        content: Text('"${product.title}"'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await widget.viewModel.deleteProduct(product.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto excluído.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          ValueListenableBuilder<ProductState>(
            valueListenable: widget.viewModel.state,
            builder: (_, state, __) => Badge(
              label: Text('${state.favoriteCount}'),
              isLabelVisible: state.favoriteCount > 0,
              child: IconButton(
                icon: const Icon(Icons.star, color: Colors.amber),
                tooltip: 'Favoritos',
                onPressed: () => _showFavorites(context, state),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: widget.viewModel.loadProducts,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductFormPage(viewModel: widget.viewModel)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Buscando produtos...'),
            ]));
          }

          if (state.error != null) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: widget.viewModel.loadProducts,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ]),
            ));
          }

          if (state.products.isEmpty) return const Center(child: Text('Nenhum produto encontrado.'));

          return Column(children: [
            if (state.fromCache)
              Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: const Row(children: [
                  Icon(Icons.offline_bolt, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Exibindo dados do cache (sem conexão)', style: TextStyle(fontSize: 12, color: Colors.orange)),
                ]),
              ),
            _CategoryFilter(viewModel: widget.viewModel, state: state),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: state.filtered.length,
                itemBuilder: (_, i) {
                  final product = state.filtered[i];
                  return Dismissible(
                    key: ValueKey(product.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async { await _confirmDelete(product); return false; },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: _ProductCard(
                      product: product,
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product, viewModel: widget.viewModel),
                      )),
                      onFavorite: () => widget.viewModel.toggleFavorite(product),
                      onEdit: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ProductFormPage(viewModel: widget.viewModel, product: product),
                      )),
                      onDelete: () => _confirmDelete(product),
                    ),
                  );
                },
              ),
            ),
          ]);
        },
      ),
    );
  }

  void _showFavorites(BuildContext context, ProductState state) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Favoritos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        if (state.favorites.isEmpty)
          const Expanded(child: Center(child: Text('Nenhum favorito ainda.')))
        else
          Expanded(child: ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (_, i) {
              final p = state.favorites[i];
              return ListTile(
                leading: Image.network(p.image, width: 40, height: 40, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported)),
                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('USD ${p.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () { widget.viewModel.toggleFavorite(p); Navigator.pop(context); },
                ),
              );
            },
          )),
      ]),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final ProductViewModel viewModel;
  final ProductState state;
  const _CategoryFilter({required this.viewModel, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: const Text('Todos'),
            selected: state.selectedCategory == null,
            onSelected: (_) => viewModel.filterByCategory(null),
          ),
        ),
        ...viewModel.categories.map((cat) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(cat),
            selected: state.selectedCategory == cat,
            onSelected: (_) => viewModel.filterByCategory(cat),
          ),
        )),
      ]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onFavorite,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: product.favorite ? 4 : 2,
      color: product.favorite ? Colors.amber.shade50 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(product.image, width: 72, height: 72, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 72, color: Colors.grey)),
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            ])),
            Column(children: [
              IconButton(
                icon: Icon(product.favorite ? Icons.star : Icons.star_border,
                    color: product.favorite ? Colors.amber : Colors.grey, size: 22),
                onPressed: onFavorite,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.indigo, size: 20),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
