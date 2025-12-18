import 'package:get_it/get_it.dart';
import '../utils/logger.dart';
import '../../shared/services/navigation_service.dart';
import '../../shared/services/storage_service.dart';
import '../../shared/services/clipboard_service.dart';
import '../../shared/services/download_service.dart';
import '../../shared/services/notification_service.dart';

/// Service Locator for dependency injection
/// Manages all application services and their lifecycle
class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;
  static bool _initialized = false;

  /// Initialize all services
  static Future<void> initialize() async {
    if (_initialized) {
      AppLogger.warning('ServiceLocator already initialized');
      return;
    }

    try {
      AppLogger.info('Initializing ServiceLocator...');

      // Register services as singletons
      _getIt.registerLazySingleton<NavigationService>(
        () => NavigationService(),
      );
      _getIt.registerLazySingleton<StorageService>(() => StorageService());
      _getIt.registerLazySingleton<ClipboardService>(() => ClipboardService());
      _getIt.registerLazySingleton<NotificationService>(
        () => NotificationService(),
      );
      _getIt.registerLazySingleton<DownloadService>(() => DownloadService());

      // Initialize services that need it
      await _getIt<StorageService>().initialize();
      await _getIt<NotificationService>().initialize();
      await _getIt<DownloadService>().initialize();

      _initialized = true;
      AppLogger.info('ServiceLocator initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize ServiceLocator', e);
      rethrow;
    }
  }

  /// Get a service instance
  static T get<T extends Object>() {
    if (!_initialized) {
      throw Exception(
        'ServiceLocator not initialized. Call initialize() first.',
      );
    }
    return _getIt<T>();
  }

  /// Get NavigationService
  static NavigationService get navigation => get<NavigationService>();

  /// Get StorageService
  static StorageService get storage => get<StorageService>();

  /// Get ClipboardService
  static ClipboardService get clipboard => get<ClipboardService>();

  /// Get NotificationService
  static NotificationService get notification => get<NotificationService>();

  /// Get DownloadService
  static DownloadService get download => get<DownloadService>();

  /// Check if a service is registered
  static bool isRegistered<T extends Object>() {
    return _getIt.isRegistered<T>();
  }

  /// Reset all services (useful for testing)
  static Future<void> reset() async {
    try {
      AppLogger.info('Resetting ServiceLocator...');

      // Dispose services that need cleanup
      if (isRegistered<NotificationService>()) {
        get<NotificationService>().dispose();
      }

      if (isRegistered<DownloadService>()) {
        get<DownloadService>().dispose();
      }

      _getIt.reset();
      _initialized = false;
      AppLogger.info('ServiceLocator reset successfully');
    } catch (e) {
      AppLogger.error('Failed to reset ServiceLocator', e);
      rethrow;
    }
  }

  /// Dispose all services and cleanup
  static Future<void> dispose() async {
    try {
      AppLogger.info('Disposing ServiceLocator...');
      await reset();
      AppLogger.info('ServiceLocator disposed successfully');
    } catch (e) {
      AppLogger.error('Failed to dispose ServiceLocator', e);
      rethrow;
    }
  }
}

/// Extension for easy service access
extension ServiceLocatorExtension on Object {
  /// Get NavigationService
  NavigationService get navigation => ServiceLocator.navigation;

  /// Get StorageService
  StorageService get storage => ServiceLocator.storage;

  /// Get ClipboardService
  ClipboardService get clipboard => ServiceLocator.clipboard;

  /// Get NotificationService
  NotificationService get notification => ServiceLocator.notification;

  /// Get DownloadService
  DownloadService get download => ServiceLocator.download;
}
