import '../../domain/entities/product.dart';

/// Estado imutável da tela de produtos.
///
/// Representa explicitamente os três estados da interface:
/// - Carregando: [isLoading] == true
/// - Erro:       [error] != null
/// - Sucesso:    [products] não vazio
class ProductState {
  final bool isLoading;
  final List<Product> products;
  final List<Product> filtered;
  final String? selectedCategory;
  final String? error;

  /// Indica se os dados exibidos vieram do cache (modo offline).
  final bool fromCache;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.filtered = const [],
    this.selectedCategory,
    this.error,
    this.fromCache = false,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    List<Product>? filtered,
    String? selectedCategory,
    String? error,
    bool? fromCache,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      filtered: filtered ?? this.filtered,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}
