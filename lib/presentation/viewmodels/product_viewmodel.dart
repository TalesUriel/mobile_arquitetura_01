import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;
  final ValueNotifier<ProductState> state = ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  // ── [R] Carregar ──────────────────────────────────────────────────────
  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
        filtered: products,
        fromCache: false,
      );
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── [C] Criar ─────────────────────────────────────────────────────────
  Future<bool> addProduct(Product product) async {
    try {
      final created = await repository.addProduct(product);
      final updated = [created, ...state.value.products];
      state.value = state.value.copyWith(products: updated, filtered: updated);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return false;
    }
  }

  // ── [U] Atualizar ─────────────────────────────────────────────────────
  Future<bool> updateProduct(Product product) async {
    try {
      final updated = await repository.updateProduct(product);
      final list = state.value.products.map((p) => p.id == updated.id ? updated : p).toList();
      state.value = state.value.copyWith(products: list, filtered: list);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return false;
    }
  }

  // ── [D] Deletar ───────────────────────────────────────────────────────
  Future<bool> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      final list = state.value.products.where((p) => p.id != id).toList();
      state.value = state.value.copyWith(products: list, filtered: list);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return false;
    }
  }

  // ── Favorito ──────────────────────────────────────────────────────────
  void toggleFavorite(Product product) {
    product.favorite = !product.favorite;
    // força rebuild copiando a lista para o state reconhecer a mudança
    final list = [...state.value.products];
    state.value = state.value.copyWith(products: list, filtered: [...state.value.filtered]);
  }

  // ── Filtro por categoria ──────────────────────────────────────────────
  void filterByCategory(String? category) {
    final all = state.value.products;
    state.value = state.value.copyWith(
      filtered: category == null ? all : all.where((p) => p.category == category).toList(),
      selectedCategory: category,
    );
  }

  List<String> get categories =>
      state.value.products.map((p) => p.category).toSet().toList()..sort();
}
