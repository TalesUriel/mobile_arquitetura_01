import '../entities/product.dart';

/// Contrato que define as operações disponíveis sobre produtos.
/// A implementação concreta fica na camada de dados,
/// preservando a independência do domínio.
abstract class ProductRepository {
  /// Retorna a lista completa de produtos disponíveis.
  Future<List<Product>> getProducts();
}
