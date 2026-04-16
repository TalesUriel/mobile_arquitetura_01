import '../../core/network/http_client.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final HttpClient client;
  ProductRemoteDatasource(this.client);

  static const _base = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(_base);
    final List data = response.data as List;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> addProduct(ProductModel model) async {
    final response = await client.post(_base, model.toJson());
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(ProductModel model) async {
    final response = await client.put('$_base/${model.id}', model.toJson());
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await client.delete('$_base/$id');
  }
}
