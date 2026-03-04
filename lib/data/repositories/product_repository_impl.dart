import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

/// Implementação concreta do [ProductRepository].
/// Coordena o datasource remoto e converte os modelos de dados
/// em entidades de domínio antes de retorná-las às camadas superiores.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();

      // Converte cada ProductModel em entidade de domínio Product
      return models
          .map((m) => Product(
                id: m.id,
                title: m.title,
                price: m.price,
                image: m.image,
                category: m.category,
                description: m.description,
              ))
          .toList();
    } catch (e) {
      // Encapsula qualquer erro em Failure padronizado
      throw Failure(e.toString());
    }
  }
}
