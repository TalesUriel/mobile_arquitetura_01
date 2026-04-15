import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(name: 'Notebook Gamer', price: 4500.00),
    Product(name: 'Mouse Sem Fio', price: 120.00),
    Product(name: 'Teclado Mecânico', price: 350.00),
    Product(name: 'Monitor 27"', price: 1800.00),
    Product(name: 'Headset RGB', price: 280.00),
    Product(name: 'Webcam Full HD', price: 230.00),
  ];

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get favorites => _products.where((p) => p.favorite).toList();
  int get favoriteCount => favorites.length;

  void toggleFavorite(Product product) {
    product.favorite = !product.favorite;
    notifyListeners();
  }
}
