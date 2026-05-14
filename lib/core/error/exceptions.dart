class NetworkException implements Exception {
  const NetworkException([this.message = 'Error de red.']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Error de caché.']);
  final String message;
}

class AuthException implements Exception {
  const AuthException([this.message = 'No autorizado.']);
  final String message;
}

class ServerException implements Exception {
  const ServerException({this.statusCode, this.message = 'Error del servidor.'});
  final int? statusCode;
  final String message;
}
