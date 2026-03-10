import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_cache_datasource.dart';
import '../datasources/product_remote_datasource.dart';

/// Implementação concreta do [ProductRepository].
///
/// Estratégia:
/// 1. Tenta buscar da API (fonte primária).
/// 2. Em caso de sucesso, salva no cache.
/// 3. Em caso de falha, serve dados do cache (fallback).
/// 4. Se o cache também estiver vazio, lança [Failure].
///
/// [RESPOSTA À REFLEXÃO 4]
/// Para substituir a API por banco de dados local, basta criar um novo
/// datasource e injetá-lo aqui. Nenhuma outra camada precisa mudar.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Tenta buscar da API
      final models = await remote.getProducts();

      // Sucesso: persiste no cache para uso offline
      cache.save(models);

      return _toEntities(models);
    } catch (e) {
      // Falha: verifica se há dados em cache
      if (cache.hasData) {
        return _toEntities(cache.get()!);
      }
      throw Failure('Não foi possível carregar os produtos. Verifique sua conexão.');
    }
  }

  List<Product> _toEntities(List<dynamic> models) {
    return models.map((m) => Product(
          id: m.id,
          title: m.title,
          price: m.price,
          image: m.image,
          category: m.category,
          description: m.description,
        )).toList();
  }
}
