
class ApiException implements Exception {
  final String mensagem;
  final int? statusCode;

  const ApiException(this.mensagem, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $mensagem';
}
