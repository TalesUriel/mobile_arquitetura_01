import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Loja'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            Consumer<ProductProvider>(
              builder: (_, p, __) => Badge(
                label: Text('${p.favoriteCount}'),
                isLabelVisible: p.favoriteCount > 0,
                child: const Icon(Icons.star, color: Colors.amber),
              ),
            ),
            const SizedBox(width: 16),
          ],
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.list), text: 'Todos'),
            Tab(icon: Icon(Icons.star), text: 'Favoritos'),
          ]),
        ),
        body: TabBarView(children: [
          Consumer<ProductProvider>(
            builder: (_, p, __) => ListView.builder(
              itemCount: p.products.length,
              itemBuilder: (_, i) => ProductCard(product: p.products[i]),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (_, p, __) => p.favorites.isEmpty
                ? const Center(child: Text('Nenhum favorito ainda.'))
                : ListView.builder(
                    itemCount: p.favorites.length,
                    itemBuilder: (_, i) => ProductCard(product: p.favorites[i]),
                  ),
          ),
        ]),
      ),
    );
  }
}
