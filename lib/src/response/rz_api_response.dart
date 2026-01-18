import 'rz_api_error.dart';
import 'rz_api_success.dart';
import 'rz_api_failure.dart';

abstract class RzApiResponse<T> {
  const RzApiResponse();

  R when<R>({
    required R Function(T data) success,
    required R Function(RzApiError error) failure,
  });

  factory RzApiResponse.success(T data) = RzApiSuccess<T>;
  factory RzApiResponse.failure(RzApiError error) = RzApiFailure<T>;
}