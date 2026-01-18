import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RzLoggingInterceptor extends PrettyDioLogger {
  RzLoggingInterceptor()
      : super(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    compact: true,
  );
}