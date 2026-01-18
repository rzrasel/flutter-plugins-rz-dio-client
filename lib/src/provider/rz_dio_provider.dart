import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';

import '../client/rz_dio_client_obj.dart';

class RzDioProvider {
  static RzDioProvider? _instance;
  late final dio.Dio _dio;
  String? _authToken;
  String _bearerPrefix = 'Bearer';

  /// Private constructor
  RzDioProvider._internal({
    String? authToken,
    VoidCallback? onUnauthorized,
    String? baseUrl,
  }) {
    _authToken = authToken;
    _dio = RzDioClient.buildClient(
      authToken: authToken,
      onUnauthorized: onUnauthorized,
      baseUrl: baseUrl,
    );
    // Set default responseType globally
    _dio.options.responseType = dio.ResponseType.json;
  }

  /// Factory constructor (Singleton)
  factory RzDioProvider({
    String? authToken,
    VoidCallback? onUnauthorized,
    String? baseUrl,
  }) {
    _instance ??= RzDioProvider._internal(
      authToken: authToken,
      onUnauthorized: onUnauthorized,
      baseUrl: baseUrl,
    );
    return _instance!;
  }

  // Content Type: application/json - multipart/form-data
  static void setContentType({String contentType = "application/json"}) {
    RzDioClient.setContentType(contentType: contentType);
  }

  /// Static method to set interceptors (call before instantiation)
  static void setInterceptors(dynamic interceptors) {
    RzDioClient.setInterceptors(interceptors);
  }

  /// Static method to set timeouts (proxies to RzDioClient)
  static void setTimeout({
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
  }) {
    RzDioClient.setTimeout(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );
  }

  /// Set auth token dynamically
  RzDioProvider setAuth(String? token, {String bearerPrefix = 'Bearer'}) {
    _authToken = token;
    _bearerPrefix = bearerPrefix;
    RzDioClient.setAuth(token, bearerPrefix: bearerPrefix);
    return this;
  }

  RzDioProvider setToken(String? token, {String bearerPrefix = 'Bearer'}) {
    _authToken = token;
    _bearerPrefix = bearerPrefix;
    RzDioClient.setAuth(token, bearerPrefix: bearerPrefix);
    return this;
  }

  static dio.CancelToken createCancelToken() {
    return dio.CancelToken();
  }

  /// Optional: reset instance (useful on logout)
  static void reset() {
    _instance = null;
  }

  /* --------------------------------------------------------------------------
   * HTTP METHODS
   * -------------------------------------------------------------------------- */
  Future<dio.Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<dio.Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<dio.Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<dio.Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}