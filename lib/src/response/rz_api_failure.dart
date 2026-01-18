import 'rz_api_error.dart';
import 'rz_api_response.dart';

class RzApiFailure<T> extends RzApiResponse<T> {
  final RzApiError error;

  const RzApiFailure(this.error);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(RzApiError error) failure,
  }) {
    return failure(error);
  }
}