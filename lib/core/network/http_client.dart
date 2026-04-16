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
      throw Failure(e.message ?? 'Erro de comunicação.');
    } catch (e) {
      throw Failure('Erro inesperado: $e');
    }
  }

  Future<Response> post(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.post(url, data: data);
    } on DioException catch (e) {
      throw Failure(e.message ?? 'Erro de comunicação.');
    } catch (e) {
      throw Failure('Erro inesperado: $e');
    }
  }

  Future<Response> put(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.put(url, data: data);
    } on DioException catch (e) {
      throw Failure(e.message ?? 'Erro de comunicação.');
    } catch (e) {
      throw Failure('Erro inesperado: $e');
    }
  }

  Future<Response> delete(String url) async {
    try {
      return await _dio.delete(url);
    } on DioException catch (e) {
      throw Failure(e.message ?? 'Erro de comunicação.');
    } catch (e) {
      throw Failure('Erro inesperado: $e');
    }
  }
}
