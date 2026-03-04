import 'package:dio/dio.dart';
import '../errors/failure.dart';

class HttpClient {
  final Dio _dio;
  HttpClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<Response> get(String url) async {
    try {
      return await _dio.get(url);
    } on DioException catch (e) {
      throw Failure(e.message ?? 'Erro de comunicacao com o servidor.');
    } catch (e) {
      throw Failure('Erro inesperado: $e');
    }
  }
}
