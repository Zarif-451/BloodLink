class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final Map<String, List<String>>? fieldErrors;

  ApiException({
    this.statusCode,
    required this.message,
    this.fieldErrors,
  });

  factory ApiException.fromDioException(dynamic error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('error')) {
        return ApiException(
          statusCode: statusCode,
          message: data['error'] as String,
        );
      }

      final fieldErrors = <String, List<String>>{};
      data.forEach((key, value) {
        if (value is List) {
          fieldErrors[key] = value.cast<String>();
        } else if (value is String) {
          fieldErrors[key] = [value];
        }
      });
      if (fieldErrors.isNotEmpty) {
        return ApiException(
          statusCode: statusCode,
          message: 'Validation failed',
          fieldErrors: fieldErrors,
        );
      }
    }

    return ApiException(
      statusCode: statusCode,
      message: _messageForStatus(statusCode),
    );
  }

  static String _messageForStatus(int? code) {
    switch (code) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'You do not have permission.';
      case 404:
        return 'Not found';
      case 409:
        return 'Conflict. Related records exist.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}