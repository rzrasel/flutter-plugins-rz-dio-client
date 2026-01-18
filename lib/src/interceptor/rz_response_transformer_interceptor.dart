import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class RzResponseTransformerInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if response.data is a String and likely JSON
    if (response.data is String) {
      final contentType = response.headers.value('content-type');
      if (contentType?.contains('application/json') == true || _isJsonString(response.data)) {
        try {
          response.data = jsonDecode(response.data as String);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Failed to parse JSON response: $e');
          }
          // Proceed with the original string data
        }
      }
    }
    handler.next(response);
  }

  bool _isJsonString(dynamic data) {
    if (data is! String) return false;
    final trimmed = (data).trim();
    return trimmed.startsWith('{') || trimmed.startsWith('[');
  }
}