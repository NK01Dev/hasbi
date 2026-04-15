/// Exception thrown when a call to the consolidated finance API fails.
///
/// Wraps the HTTP [statusCode], a human-readable [message], and the raw
/// [responseBody] returned by the Appwrite function execution.
class FinanceApiException implements Exception {
  final int statusCode;
  final String message;
  final String? responseBody;

  const FinanceApiException({
    required this.statusCode,
    required this.message,
    this.responseBody,
  });

  @override
  String toString() => 'FinanceApiException($statusCode): $message';
}
