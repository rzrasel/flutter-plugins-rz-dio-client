import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class RzNetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final List<ConnectivityResult> connectivity =
    await Connectivity().checkConnectivity();

    if (connectivity.contains(ConnectivityResult.none)) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No Internet connection',
        ),
      );
      return;
    }

    handler.next(options);
  }
}