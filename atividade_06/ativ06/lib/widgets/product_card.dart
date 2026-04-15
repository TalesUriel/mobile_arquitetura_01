import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: product.favorite ? Colors.amber.shade50 : null,
      child: ListTile(
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(
            product.favorite ? Icons.star : Icons.star_border,
            color: product.favorite ? Colors.amber : Colors.grey,
          ),
          onPressed: () => context.read<ProductProvider>().toggleFavorite(product),
        ),
      ),
    );
  }
}
