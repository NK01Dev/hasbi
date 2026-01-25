import 'package:logger/logger.dart';

class AppLogger {
  // Singleton pattern
  AppLogger._internal();
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;

  // The actual Logger instance
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to show in stack trace
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // CRITICAL for debugging performance/timeline
      noBoxingByDefault: false,
    ),
  );

  // --- Convenience Methods ---

  void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}