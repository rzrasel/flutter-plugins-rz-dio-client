class RzApiError {
  final int? statusCode;
  final String message;
  final dynamic raw;

  const RzApiError({
    this.statusCode,
    required this.message,
    this.raw,
  });

  factory RzApiError.unknown([dynamic raw]) {
    return RzApiError(
      message: 'Unknown error occurred',
      raw: raw,
    );
  }

  factory RzApiError.network([dynamic raw]) {
    return RzApiError(
      message: 'Network error. Please check your connection.',
      raw: raw,
    );
  }

  factory RzApiError.server({
    int? statusCode,
    String? message,
    dynamic raw,
  }) {
    return RzApiError(
      statusCode: statusCode,
      message: message ?? 'Server error occurred',
      raw: raw,
    );
  }
}