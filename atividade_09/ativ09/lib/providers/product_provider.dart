import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final _service = ProductService();
  List<Product> _products = [];
  bool isLoading = false;
  String? error;

  List<Product> get products => List.unmodifiable(_products);

  Future<void> fetchProducts() async {
    isLoading = true; error = null; notifyListeners();
    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      error = 'Erro ao carregar: $e';
    } finally {
      isLoading = false; notifyListeners();
    }
  }

  Future<bool> addProduct(Product p) async {
    try {
      _products.insert(0, await _service.addProduct(p));
      notifyListeners(); return true;
    } catch (e) {
      error = '$e'; notifyListeners(); return false;
    }
  }

  Future<bool> updateProduct(Product p) async {
    try {
      final updated = await _service.updateProduct(p);
      final i = _products.indexWhere((x) => x.id == p.id);
      if (i != -1) { _products[i] = updated; notifyListeners(); }
      return true;
    } catch (e) {
      error = '$e'; notifyListeners(); return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _service.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners(); return true;
    } catch (e) {
      error = '$e'; notifyListeners(); return false;
    }
  }
}
