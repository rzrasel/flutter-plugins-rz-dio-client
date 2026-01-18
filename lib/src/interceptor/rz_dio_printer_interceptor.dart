import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

void printer(dynamic value) {
  if (kDebugMode) {
    debugPrint(value.toString());
  }
}

class RzDioPrinterInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    printer("= = = DIO REQUEST = = =");
    printer("METHOD       : ${options.method}");
    printer("URL          : ${options.baseUrl}${options.path}");
    printer("HEADERS      : ${options.headers}");
    printer("CONTENT_TYPE : ${options.contentType}");
    printer("QUERY        : ${options.queryParameters}");
    printer("EXTRA        : ${options.extra}");
    printer("BODY         : ${options.data}");
    printer("==========================");

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    printer("= = = DIO RESPONSE = = =");
    printer("URL         : ${response.requestOptions.baseUrl}${response.requestOptions.path}");
    printer("STATUS CODE : ${response.statusCode}");
    printer("HEADERS     : ${response.headers}");
    printer("EXTRA       : ${response.extra}");
    printer("DATA        : ${jsonEncode(response.data)}");
    printer("==========================");

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    printer("= = = DIO ERROR = = =");
    printer("URL         : ${err.requestOptions.baseUrl}${err.requestOptions.path}");
    printer("TYPE        : ${err.type}");
    printer("MESSAGE     : ${err.message}");
    printer("STATUS CODE : ${err.response?.statusCode}");
    printer("RESPONSE    : ${err.response?.data}");
    printer("==========================");

    handler.next(err);
  }
}