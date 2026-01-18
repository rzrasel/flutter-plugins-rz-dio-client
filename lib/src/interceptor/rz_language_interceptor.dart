import 'package:dio/dio.dart';

class RzLanguageInterceptor extends Interceptor {
  final String header;
  final String language;

  RzLanguageInterceptor(this.language, {this.header = 'Accept-Language'});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[header] = language;
    handler.next(options);
  }
}
