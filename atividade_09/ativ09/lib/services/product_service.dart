import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductService {
  static const _base = 'https://fakestoreapi.com/products';
  final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));

  Future<List<Product>> fetchProducts() async {
    final r = await _dio.get(_base);
    return (r.data as List).map((j) => Product.fromJson(j)).toList();
  }

  Future<Product> addProduct(Product p) async {
    final r = await _dio.post(_base, data: p.toJson());
    return Product.fromJson(r.data);
  }

  Future<Product> updateProduct(Product p) async {
    final r = await _dio.put('$_base/${p.id}', data: p.toJson());
    return Product.fromJson(r.data);
  }

  Future<void> deleteProduct(int id) async => _dio.delete('$_base/$id');
}
