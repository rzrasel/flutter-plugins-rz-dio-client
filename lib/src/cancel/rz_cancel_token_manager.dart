import 'package:dio/dio.dart';

class RzCancelTokenManager {
  CancelToken? _token;

  CancelToken get token {
    _token ??= CancelToken();
    return _token!;
  }

  void cancel([String reason = 'Request cancelled']) {
    if (_token != null && !_token!.isCancelled) {
      _token!.cancel(reason);
    }
    _token = null;
  }

  void reset() {
    _token = null;
  }
}