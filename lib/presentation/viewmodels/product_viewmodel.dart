import 'package:flutter/foundation.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

/// ViewModel que coordena as ações da tela de produtos.
///
/// [RESPOSTA À REFLEXÃO 2]
/// O ViewModel não deve fazer chamadas HTTP diretamente porque isso
/// acoplaria a camada de apresentação a detalhes de infraestrutura.
/// Ficaria impossível testar sem rede real, e qualquer mudança na API
/// exigiria alterar a UI. O ViewModel deve apenas coordenar estado
/// e delegar operações ao repositório.
class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  /// Carrega produtos (API ou cache). Atualiza estado para
  /// loading → sucesso ou erro.
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
      state.value = state.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filtra produtos pela [category]. Null remove o filtro.
  void filterByCategory(String? category) {
    final all = state.value.products;
    if (category == null || category.isEmpty) {
      state.value = state.value.copyWith(filtered: all, selectedCategory: null);
    } else {
      state.value = state.value.copyWith(
        filtered: all.where((p) => p.category == category).toList(),
        selectedCategory: category,
      );
    }
  }

  /// Categorias únicas disponíveis, ordenadas alfabeticamente.
  List<String> get categories =>
      state.value.products.map((p) => p.category).toSet().toList()..sort();
}
