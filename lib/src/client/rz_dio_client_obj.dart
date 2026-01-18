import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../interceptor/rz_auth_interceptor.dart';

class RzDioClient {
  static int connectTimeout = 300000;
  static int receiveTimeout = 300000;
  static int? sendTimeout = 300000;
  static String contentType = 'application/json';
  static List<Interceptor> interceptors = [];
  static VoidCallback? _onUnauthorized;

  static Dio? _dio;

  static Dio get instance {
    _dio ??= buildClient();
    return _dio!;
  }

  static Dio buildClient({
    String? authToken,
    VoidCallback? onUnauthorized,
    String? baseUrl,
  }) {
    if (_dio != null) return _dio!;
    _onUnauthorized = onUnauthorized;
    final options = BaseOptions(
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      // Web-safe sendTimeout
      sendTimeout: _resolveSendTimeout(),
      headers: {
        'Content-Type': contentType,
        'Accept': contentType,
      },
      responseType: ResponseType.json,
    );

    print("===========$baseUrl=========");
    // Set baseUrl only if it's not null
    if (baseUrl != null && baseUrl.isNotEmpty) {
      options.baseUrl = baseUrl;
    }
    final dio = Dio(options);

    if (authToken != null || onUnauthorized != null) {
      dio.interceptors.add(
          RzAuthInterceptor(
            authToken: authToken,
            onUnauthorized: onUnauthorized,
          )
      );
    }

    // if not empty interceptors add interceptors
    if (interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
    _dio = dio;
    return dio;
  }

  static void setContentType({String contentType = "application/json"}) {
    RzDioClient.contentType = contentType;
    final dio = _dio;
    if (dio == null) return;

    // Update Dio options
    dio.options.contentType = contentType;
    dio.options.headers['Content-Type'] = contentType;
    dio.options.headers['Accept'] = contentType;
  }

  // Static method to set the static interceptors list
  // Accepts single Interceptor or List<Interceptor>
  static void setInterceptors(dynamic interceptors) {
    List<Interceptor> toAdd = [];
    if (interceptors is Interceptor) {
      toAdd.add(interceptors);
    } else if (interceptors is List) {
      toAdd.addAll(interceptors.cast<Interceptor>());
    }
    RzDioClient.interceptors = toAdd;

    final dio = _dio;
    if (dio != null) {
      for (final interceptor in toAdd) {
        dio.interceptors.removeWhere(
              (e) => e.runtimeType == interceptor.runtimeType,
        );
        dio.interceptors.add(interceptor);
      }
    }
  }

  // Static method to set timeouts dynamically
  // Accepts optional named parameters for connect, read, and write timeouts in milliseconds
  static void setTimeout({
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout = null,
  }) {
    if (connectTimeout != null) {
      RzDioClient.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      RzDioClient.receiveTimeout = receiveTimeout;
    }
    // Force-disable sendTimeout on Web
    RzDioClient.sendTimeout = kIsWeb ? null : sendTimeout;
  }

  static void setAuth(String? token, {String bearerPrefix = 'Bearer'}) {
    final dio = instance;

    // Remove old auth interceptor if exists
    dio.interceptors.removeWhere((element) => element is RzAuthInterceptor);

    if (token != null && token.trim().isNotEmpty) {
      dio.interceptors.add(
        RzAuthInterceptor(
          authToken: token,
          bearerPrefix: bearerPrefix,
          onUnauthorized: _onUnauthorized,
        ),
      );
    }
  }

  /// Web-safe resolver
  static Duration? _resolveSendTimeout() {
    if (kIsWeb) return null;
    if (sendTimeout == null) return null;
    return Duration(milliseconds: sendTimeout!);
  }

  static void clearAuth() {
    final dio = _dio;
    if (dio == null) return;
    dio.interceptors.removeWhere((e) => e is RzAuthInterceptor);
  }
}