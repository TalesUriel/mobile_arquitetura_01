import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  ProductRepositoryImpl(this.remote);
  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      return models.map((m) => Product(
        id: m.id, title: m.title, price: m.price,
        image: m.image, category: m.category, description: m.description,
      )).toList();
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
