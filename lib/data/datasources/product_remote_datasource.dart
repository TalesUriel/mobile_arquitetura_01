import '../../core/network/http_client.dart';
import '../models/product_model.dart';

/// Datasource responsável por buscar produtos na Fake Store API.
/// Concentra exclusivamente operações de I/O de rede,
/// sem conter regras de negócio.
class ProductRemoteDatasource {
  final HttpClient client;

  ProductRemoteDatasource(this.client);

  /// Busca a lista de produtos na API e converte para [ProductModel].
  /// Lança [FormatException] se algum item vier com dados inválidos.
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get('https://fakestoreapi.com/products');
    final List data = response.data as List;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
