import 'package:flutter/foundation.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

/// ViewModel responsável por coordenar as ações da tela de produtos.
/// Gerencia o estado observado pela interface e delega operações
/// ao repositório de domínio. Não contém regras de negócio.
class ProductViewModel {
  final ProductRepository repository;

  /// Estado observável da tela. A UI reconstrói automaticamente
  /// sempre que [state.value] é atualizado.
  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  /// Carrega os produtos da API e atualiza o estado da tela.
  Future<void> loadProducts() async {
    // Indica início do carregamento
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
        filtered: products, // sem filtro inicial: exibe todos
      );
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filtra os produtos pela [category] informada.
  /// Se [category] for nulo ou vazio, remove o filtro e exibe todos.
  void filterByCategory(String? category) {
    final all = state.value.products;

    if (category == null || category.isEmpty) {
      // Remove filtro — exibe todos os produtos
      state.value = state.value.copyWith(
        filtered: all,
        selectedCategory: null,
      );
    } else {
      // Aplica filtro por categoria
      final filtered =
          all.where((p) => p.category == category).toList();
      state.value = state.value.copyWith(
        filtered: filtered,
        selectedCategory: category,
      );
    }
  }

  /// Retorna a lista de categorias únicas disponíveis nos produtos.
  List<String> get categories {
    return state.value.products
        .map((p) => p.category)
        .toSet()
        .toList()
      ..sort();
  }
}
