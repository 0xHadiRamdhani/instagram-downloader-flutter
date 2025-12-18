import 'dart:developer' as developer;
import 'package:logger/logger.dart' as external_logger;

/// Custom logger for the application
/// Provides structured logging with different levels
class AppLogger {
  static final external_logger.Logger _logger = external_logger.Logger(
    printer: external_logger.PrettyPrinter(
      methodCount: 2,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: external_logger.Level.debug,
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    developer.log('DEBUG: $message', name: 'InstagramDownloader');
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    developer.log('INFO: $message', name: 'InstagramDownloader');
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    developer.log('WARNING: $message', name: 'InstagramDownloader');
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log('ERROR: $message', name: 'InstagramDownloader');
  }

  /// Log verbose message
  static void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error: error, stackTrace: stackTrace);
    developer.log('VERBOSE: $message', name: 'InstagramDownloader');
  }

  /// Log wtf (what a terrible failure) message
  static void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error: error, stackTrace: stackTrace);
    developer.log('WTF: $message', name: 'InstagramDownloader');
  }

  /// Log network request
  static void network(
    String method,
    String url, {
    int? statusCode,
    String? response,
    dynamic error,
  }) {
    final message =
        'NETWORK: $method $url${statusCode != null ? ' - Status: $statusCode' : ''}';

    if (error != null) {
      _logger.e(message, error: error);
      developer.log(message, name: 'InstagramDownloader.Network', error: error);
    } else {
      _logger.d(message);
      developer.log(message, name: 'InstagramDownloader.Network');
    }
  }

  /// Log download progress
  static void downloadProgress(
    String downloadId,
    double progress, {
    String? status,
  }) {
    final message =
        'DOWNLOAD: $downloadId - Progress: ${(progress * 100).toStringAsFixed(1)}%${status != null ? ' - Status: $status' : ''}';
    _logger.d(message);
    developer.log(message, name: 'InstagramDownloader.Download');
  }

  /// Log download complete
  static void downloadComplete(String downloadId, String filePath) {
    final message = 'DOWNLOAD COMPLETE: $downloadId - File: $filePath';
    _logger.i(message);
    developer.log(message, name: 'InstagramDownloader.Download');
  }

  /// Log download failed
  static void downloadFailed(String downloadId, String error) {
    final message = 'DOWNLOAD FAILED: $downloadId - Error: $error';
    _logger.e(message);
    developer.log(message, name: 'InstagramDownloader.Download', error: error);
  }

  /// Log clipboard detection
  static void clipboardDetect(String url) {
    final message = 'CLIPBOARD: Detected Instagram URL - $url';
    _logger.i(message);
    developer.log(message, name: 'InstagramDownloader.Clipboard');
  }

  /// Log permission request
  static void permissionRequest(String permission, bool granted) {
    final message =
        'PERMISSION: $permission - ${granted ? 'GRANTED' : 'DENIED'}';
    _logger.i(message);
    developer.log(message, name: 'InstagramDownloader.Permission');
  }

  /// Log storage operation
  static void storageOperation(
    String operation,
    String path, {
    bool success = true,
    dynamic error,
  }) {
    final message =
        'STORAGE: $operation - Path: $path${success ? ' - SUCCESS' : ' - FAILED'}';

    if (error != null) {
      _logger.e(message, error: error);
      developer.log(message, name: 'InstagramDownloader.Storage', error: error);
    } else {
      _logger.d(message);
      developer.log(message, name: 'InstagramDownloader.Storage');
    }
  }

  /// Log analytics event
  static void analyticsEvent(String event, Map<String, dynamic> parameters) {
    final message = 'ANALYTICS: $event - Parameters: $parameters';
    _logger.d(message);
    developer.log(message, name: 'InstagramDownloader.Analytics');
  }

  /// Log performance metrics
  static void performanceMetric(String metric, double value, {String? unit}) {
    final message =
        'PERFORMANCE: $metric - Value: $value${unit != null ? ' $unit' : ''}';
    _logger.d(message);
    developer.log(message, name: 'InstagramDownloader.Performance');
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? parameters}) {
    final message =
        'USER ACTION: $action${parameters != null ? ' - Parameters: $parameters' : ''}';
    _logger.d(message);
    developer.log(message, name: 'InstagramDownloader.UserAction');
  }

  /// Log error with context
  static void errorWithContext(
    String context,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final message = 'ERROR CONTEXT: $context';
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log(message, name: 'InstagramDownloader.Error', error: error);
  }

  /// Log startup information
  static void startupInfo() {
    _logger.i('=== Instagram Downloader Started ===');
    developer.log(
      'Instagram Downloader Started',
      name: 'InstagramDownloader.Startup',
    );
  }

  /// Log shutdown information
  static void shutdownInfo() {
    _logger.i('=== Instagram Downloader Shutting Down ===');
    developer.log(
      'Instagram Downloader Shutting Down',
      name: 'InstagramDownloader.Shutdown',
    );
  }

  /// Enable/disable debug mode
  static void setDebugMode(bool enabled) {
    info('Debug mode ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Set log level
  static void setLogLevel(external_logger.Level level) {
    info('Log level set to: $level');
  }

  /// Clear logs (if supported)
  static void clearLogs() {
    _logger.d('Logs cleared');
    developer.log('Logs cleared', name: 'InstagramDownloader');
  }
}

/// Log levels
enum LogLevel { debug, info, warning, error, verbose, wtf }
