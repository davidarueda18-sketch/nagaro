import 'package:dio/dio.dart';
import 'package:nagaro/core/security/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
