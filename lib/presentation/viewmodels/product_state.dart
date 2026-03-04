import '../../domain/entities/product.dart';

/// Representa o estado imutável da tela de produtos.
/// Sempre que o estado muda, uma nova instância é criada via [copyWith],
/// evitando efeitos colaterais e tornando o comportamento previsível.
class ProductState {
  /// Indica se uma operação assíncrona está em andamento.
  final bool isLoading;

  /// Lista de produtos atualmente disponíveis na interface.
  final List<Product> products;

  /// Lista filtrada de produtos (por categoria selecionada).
  final List<Product> filtered;

  /// Categoria atualmente selecionada para filtro. Nulo = todas.
  final String? selectedCategory;

  /// Mensagem de erro caso alguma operação falhe.
  final String? error;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.filtered = const [],
    this.selectedCategory,
    this.error,
  });

  /// Cria uma cópia do estado alterando apenas os campos informados.
  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    List<Product>? filtered,
    String? selectedCategory,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      filtered: filtered ?? this.filtered,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }
}
