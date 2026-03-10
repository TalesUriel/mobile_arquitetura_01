import '../models/product_model.dart';

/// Datasource de cache local em memória.
///
/// [RESPOSTA À REFLEXÃO 1]
/// O cache foi implementado na camada de dados porque ela é responsável
/// por decidir COMO os dados são obtidos e armazenados. O domínio define
/// apenas O QUE precisa (contrato do repositório), sem saber se os dados
/// vêm da rede ou do cache. Isso preserva a independência do domínio.
///
/// Para persistência real, bastaria trocar esta implementação por
/// SharedPreferences ou SQLite sem alterar nenhuma outra camada.
class ProductCacheDatasource {
  List<ProductModel>? _cache;

  /// Salva a lista de produtos no cache.
  void save(List<ProductModel> products) {
    _cache = List.unmodifiable(products);
  }

  /// Retorna os produtos em cache, ou null se estiver vazio.
  List<ProductModel>? get() => _cache;

  /// Indica se há dados disponíveis no cache.
  bool get hasData => _cache != null && _cache!.isNotEmpty;

  /// Limpa o cache.
  void clear() => _cache = null;
}
