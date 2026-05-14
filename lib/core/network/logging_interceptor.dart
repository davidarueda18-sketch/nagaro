import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor() : _logger = Logger(
        printer: PrettyPrinter(methodCount: 0),
        level: kReleaseMode ? Level.off : Level.debug,
      );

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kReleaseMode) {
      _logger.d('[REQ] ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (!kReleaseMode) {
      _logger.d('[RES] ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kReleaseMode) {
      _logger.e('[ERR] ${err.response?.statusCode} ${err.requestOptions.uri}');
    }
    handler.next(err);
  }
}
