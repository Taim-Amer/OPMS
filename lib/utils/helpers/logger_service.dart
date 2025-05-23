import 'package:logger/logger.dart';

class LoggerService {
  // Private constructor
  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if an error occurs
        lineLength: 120, // width of the output
        colors: true, // colorize log messages
        printEmojis: true, // use emojis for different log levels
        printTime: false, // don't print time stamps
      ),
    );
  }

  // Singleton instance
  static final LoggerService _instance = LoggerService._internal();

  late final Logger _logger;

  // Factory constructor returns the same instance every time
  factory LoggerService() => _instance;

  // Log info-level messages
  void logInfo(String message) {
    _logger.i(message);
  }

  // Log debug-level messages
  void logDebug(String message) {
    _logger.d(message);
  }

  void json(dynamic jsonMap) {
    _logger.d(
      'JSON: $jsonMap',
    );
  }

  // Log warning-level messages
  void logWarning(String message) {
    _logger.w(message);
  }

  // Log error-level messages; allows optional error and stackTrace
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
