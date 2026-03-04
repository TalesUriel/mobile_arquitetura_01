import 'package:dio/dio.dart';
import '../errors/failure.dart';

/// Cliente HTTP centralizado que encapsula o [Dio].
/// Ao centralizar aqui, todos os datasources compartilham
/// as mesmas configurações de timeout e tratamento de erro.
class HttpClient {
  final Dio _dio;

  HttpClient()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  /// Realiza uma requisição GET na [url] informada.
  /// Lança [Failure] em caso de erro de rede ou erro inesperado.
  Future<Response> get(String url) async {
    try {
      return await _dio.get(url);
    } on DioException catch (e) {
      throw Failure(e.message ?? 'Erro de comunicação com o servidor.');
    } catch (e) {
      throw Failure('Erro inesperado: $e');
    }
  }
}
