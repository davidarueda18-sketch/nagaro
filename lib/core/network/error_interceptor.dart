import 'package:dio/dio.dart';
import 'package:nagaro/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException(err.message ?? 'Error de conexión.');

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) throw const AuthException();
        throw ServerException(
          statusCode: statusCode,
          message: 'Error del servidor ($statusCode).',
        );

      case DioExceptionType.cancel:
        break;

      case DioExceptionType.badCertificate:
        throw const NetworkException('Certificado inválido.');

      case DioExceptionType.unknown:
        throw NetworkException(err.message ?? 'Error desconocido.');
    }
    handler.next(err);
  }
}
