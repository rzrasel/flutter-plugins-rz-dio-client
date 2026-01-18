import 'rz_api_error.dart';
import 'rz_api_response.dart';

class RzApiSuccess<T> extends RzApiResponse<T> {
  final T data;

  const RzApiSuccess(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(RzApiError error) failure,
  }) {
    return success(data);
  }
}