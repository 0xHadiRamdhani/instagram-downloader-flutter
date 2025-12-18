import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../features/download/domain/entities/download_item.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _notificationStreamController =
      StreamController<String>.broadcast();

  Stream<String> get notificationStream => _notificationStreamController.stream;

  // Initialize notification service
  Future<void> initialize() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      AppLogger.info('NotificationService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize NotificationService', e);
      rethrow;
    }
  }

  // Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    try {
      final payload = response.payload;
      if (payload != null) {
        _notificationStreamController.add(payload);
        AppLogger.info('Notification tapped: $payload');
      }
    } catch (e) {
      AppLogger.error('Notification tap handling failed', e);
    }
  }

  // Show download start notification
  Future<void> showDownloadStart(DownloadItem download) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'download_channel',
            'Download Notifications',
            channelDescription: 'Notifications for Instagram downloads',
            importance: Importance.high,
            priority: Priority.high,
            color: AppColors.primary,
            icon: '@mipmap/ic_launcher',
            ongoing: true,
            autoCancel: false,
            showProgress: true,
            maxProgress: 100,
            progress: 0,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        download.id.hashCode,
        'Downloading ${download.type.displayName}',
        'From @${download.post.username}',
        details,
        payload: download.id,
      );

      AppLogger.info('Download start notification shown: ${download.id}');
    } catch (e) {
      AppLogger.error('Failed to show download start notification', e);
    }
  }

  // Show download progress notification
  Future<void> showDownloadProgress(DownloadItem download, int progress) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'download_channel',
            'Download Notifications',
            channelDescription: 'Notifications for Instagram downloads',
            importance: Importance.low,
            priority: Priority.low,
            color: AppColors.primary,
            icon: '@mipmap/ic_launcher',
            ongoing: true,
            autoCancel: false,
            showProgress: true,
            maxProgress: 100,
            progress: progress,
            onlyAlertOnce: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
      );

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        download.id.hashCode,
        'Downloading ${download.type.displayName}',
        '${download.post.username} - $progress%',
        details,
        payload: download.id,
      );

      AppLogger.info(
        'Download progress notification updated: ${download.id} - $progress%',
      );
    } catch (e) {
      AppLogger.error('Failed to show download progress notification', e);
    }
  }

  // Show download complete notification
  Future<void> showDownloadComplete(DownloadItem download) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'download_channel',
            'Download Notifications',
            channelDescription: 'Notifications for Instagram downloads',
            importance: Importance.high,
            priority: Priority.high,
            color: AppColors.success,
            icon: '@mipmap/ic_launcher',
            ongoing: false,
            autoCancel: true,
            showProgress: false,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        download.id.hashCode,
        'Download Complete',
        '${download.type.displayName} from @${download.post.username} saved successfully',
        details,
        payload: download.id,
      );

      AppLogger.info('Download complete notification shown: ${download.id}');
    } catch (e) {
      AppLogger.error('Failed to show download complete notification', e);
    }
  }

  // Show download failed notification
  Future<void> showDownloadFailed(DownloadItem download, String error) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'download_channel',
            'Download Notifications',
            channelDescription: 'Notifications for Instagram downloads',
            importance: Importance.high,
            priority: Priority.high,
            color: AppColors.error,
            icon: '@mipmap/ic_launcher',
            ongoing: false,
            autoCancel: true,
            showProgress: false,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        download.id.hashCode,
        'Download Failed',
        '${download.type.displayName} from @${download.post.username} - $error',
        details,
        payload: download.id,
      );

      AppLogger.info('Download failed notification shown: ${download.id}');
    } catch (e) {
      AppLogger.error('Failed to show download failed notification', e);
    }
  }

  // Show download paused notification
  Future<void> showDownloadPaused(DownloadItem download) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'download_channel',
            'Download Notifications',
            channelDescription: 'Notifications for Instagram downloads',
            importance: Importance.low,
            priority: Priority.low,
            color: AppColors.warning,
            icon: '@mipmap/ic_launcher',
            ongoing: true,
            autoCancel: false,
            showProgress: true,
            maxProgress: 100,
            progress: 0,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        download.id.hashCode,
        'Download Paused',
        '${download.type.displayName} from @${download.post.username}',
        details,
        payload: download.id,
      );

      AppLogger.info('Download paused notification shown: ${download.id}');
    } catch (e) {
      AppLogger.error('Failed to show download paused notification', e);
    }
  }

  // Cancel notification
  Future<void> cancelNotification(int notificationId) async {
    try {
      await _notifications.cancel(notificationId);
      AppLogger.info('Notification cancelled: $notificationId');
    } catch (e) {
      AppLogger.error('Failed to cancel notification', e);
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      AppLogger.info('All notifications cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel all notifications', e);
    }
  }

  // Show general notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool ongoing = false,
    bool autoCancel = true,
  }) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'general_channel',
            'General Notifications',
            channelDescription: 'General app notifications',
            importance: Importance.high,
            priority: Priority.high,
            color: AppColors.primary,
            icon: '@mipmap/ic_launcher',
            ongoing: ongoing,
            autoCancel: autoCancel,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(id, title, body, details, payload: payload);

      AppLogger.info('General notification shown: $id - $title');
    } catch (e) {
      AppLogger.error('Failed to show general notification', e);
    }
  }

  // Update notification
  Future<void> updateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    int? progress,
    int? maxProgress,
  }) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'general_channel',
            'General Notifications',
            channelDescription: 'General app notifications',
            importance: Importance.high,
            priority: Priority.high,
            color: AppColors.primary,
            icon: '@mipmap/ic_launcher',
            showProgress: progress != null,
            progress: progress ?? 0,
            maxProgress: maxProgress ?? 100,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(id, title, body, details, payload: payload);

      AppLogger.info('Notification updated: $id');
    } catch (e) {
      AppLogger.error('Failed to update notification', e);
    }
  }

  // Dispose resources
  void dispose() {
    _notificationStreamController.close();
  }
}

// Notification channels configuration
class NotificationChannels {
  static const String downloadChannel = 'download_channel';
  static const String generalChannel = 'general_channel';
  static const String errorChannel = 'error_channel';
}
