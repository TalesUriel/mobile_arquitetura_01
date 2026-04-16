import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_cache_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return _toEntities(models);
    } catch (e) {
      if (cache.hasData) return _toEntities(cache.get()!);
      throw Failure('Não foi possível carregar os produtos.');
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    final model = await remote.addProduct(_toModel(product));
    return _entityFromModel(model);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = await remote.updateProduct(_toModel(product));
    return _entityFromModel(model);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await remote.deleteProduct(id);
  }

  List<Product> _toEntities(List<dynamic> models) =>
      models.map((m) => _entityFromModel(m)).toList();

  Product _entityFromModel(ProductModel m) => Product(
        id: m.id,
        title: m.title,
        price: m.price,
        image: m.image,
        category: m.category,
        description: m.description,
      );

  ProductModel _toModel(Product p) => ProductModel(
        id: p.id,
        title: p.title,
        price: p.price,
        image: p.image,
        category: p.category,
        description: p.description,
      );
}
