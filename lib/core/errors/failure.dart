/// Representa uma falha padronizada da aplicação.
/// Usada para encapsular erros de rede, parsing ou regras de negócio
/// de forma consistente em todas as camadas.
class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}
