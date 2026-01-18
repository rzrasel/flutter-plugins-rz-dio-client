import 'package:dio/dio.dart';

typedef UnauthorizedCallback = void Function();

class RzAuthInterceptor extends Interceptor {
  final String? authToken;
  final UnauthorizedCallback? onUnauthorized;
  final String authorization;
  final String bearerPrefix;

  RzAuthInterceptor({
    this.authToken,
    this.onUnauthorized,
    this.authorization = 'Authorization',
    this.bearerPrefix = 'Bearer',
  });

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    if (authToken != null && authToken!.trim().isNotEmpty) {
      options.headers[authorization] =
      '$bearerPrefix ${authToken!.trim()}';
    }
    handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}
