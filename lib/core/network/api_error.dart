class ApiError {
  final String message;
  final int? statusCode;
  final ApiErrorType errorType;

  const ApiError({
    required this.message,
    this.statusCode,
    required this.errorType,
  });
}

enum ApiErrorType { network, timeout, server, unauthorized, user, unknown }
