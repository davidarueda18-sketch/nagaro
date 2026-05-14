import 'package:dio/dio.dart';
import 'package:nagaro/core/constants/app_constants.dart';
import 'package:nagaro/core/network/auth_interceptor.dart';
import 'package:nagaro/core/network/error_interceptor.dart';
import 'package:nagaro/core/network/logging_interceptor.dart';
import 'package:nagaro/core/security/secure_storage_service.dart';

Dio buildDioClient(SecureStorageService secureStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(secureStorage),
    ErrorInterceptor(),
  ]);

  return dio;
}
