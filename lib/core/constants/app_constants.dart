/// Application constants
class AppConstants {
  // App info
  static const String appName = 'Instagram Downloader';
  static const String appVersion = '1.0.0';
  static const String appPackageName = 'com.example.instagram_downloader';

  // Storage keys
  static const String downloadHistoryKey = 'download_history';
  static const String appSettingsKey = 'app_settings';
  static const String userPreferencesKey = 'user_preferences';
  static const String tutorialCompletedKey = 'tutorial_completed';
  static const String darkModeKey = 'dark_mode_enabled';
  static const String autoDownloadKey = 'auto_download_enabled';
  static const String downloadQualityKey = 'download_quality';
  static const String downloadLocationKey = 'download_location';

  // API endpoints
  static const String instagramBaseUrl = 'https://www.instagram.com';
  static const String instagramApiUrl = 'https://i.instagram.com/api/v1';
  static const String instagramGraphUrl = 'https://graph.instagram.com';

  // Download settings
  static const int maxConcurrentDownloads = 3;
  static const int maxRetryAttempts = 3;
  static const int downloadTimeoutSeconds = 30;
  static const int downloadChunkSize = 8192; // 8KB

  // File settings
  static const int maxFileNameLength = 255;
  static const String defaultFileExtension = 'jpg';
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];
  static const List<String> supportedVideoFormats = [
    'mp4',
    'mov',
    'avi',
    'mkv',
  ];

  // Quality settings
  static const String qualityHigh = 'high';
  static const String qualityMedium = 'medium';
  static const String qualityLow = 'low';
  static const String qualityAuto = 'auto';

  // Notification settings
  static const String notificationChannelId = 'download_channel';
  static const String notificationChannelName = 'Download Notifications';
  static const String notificationChannelDescription =
      'Notifications for Instagram downloads';

  // Cache settings
  static const int cacheMaxAgeHours = 24;
  static const int cacheMaxSizeMB = 100;
  static const int thumbnailCacheSizeMB = 50;

  // UI settings
  static const int maxRecentDownloads = 10;
  static const int maxSearchHistory = 20;
  static const int maxGalleryItemsPerLoad = 50;

  // Error messages
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorInvalidUrl = 'Invalid Instagram URL.';
  static const String errorNoMedia = 'No media found in this post.';
  static const String errorDownloadFailed =
      'Download failed. Please try again.';
  static const String errorStorageFull =
      'Storage is full. Please free up some space.';
  static const String errorPermissionDenied =
      'Permission denied. Please grant required permissions.';
  static const String errorUnknown = 'An unknown error occurred.';

  // Success messages
  static const String successDownloadStarted = 'Download started successfully.';
  static const String successDownloadComplete =
      'Download completed successfully.';
  static const String successDownloadPaused = 'Download paused.';
  static const String successDownloadResumed = 'Download resumed.';
  static const String successDownloadCancelled = 'Download cancelled.';
  static const String successDownloadDeleted = 'Download deleted.';

  // Tutorial messages
  static const String tutorialWelcome = 'Welcome to Instagram Downloader!';
  static const String tutorialClipboard =
      'We automatically detect Instagram links from your clipboard.';
  static const String tutorialPreview = 'Preview media before downloading.';
  static const String tutorialQuality = 'Choose your preferred quality.';
  static const String tutorialDownload =
      'Downloads continue in the background.';
  static const String tutorialGallery = 'View your downloads in the gallery.';
  static const String tutorialShare = 'Share downloaded media with friends.';

  // Regex patterns
  static const String instagramUrlPattern =
      r'https?://(www\.)?instagram\.com/(p|reel|tv|stories)/([a-zA-Z0-9_-]+)/?';
  static const String instagramUsernamePattern = r'@[a-zA-Z0-9_.]+';
  static const String hashtagPattern = r'#[a-zA-Z0-9_]+';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Retry settings
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const double retryBackoffMultiplier = 2.0;

  // Analytics
  static const String analyticsEventDownloadStart = 'download_start';
  static const String analyticsEventDownloadComplete = 'download_complete';
  static const String analyticsEventDownloadFailed = 'download_failed';
  static const String analyticsEventDownloadCancelled = 'download_cancelled';
  static const String analyticsEventAppLaunch = 'app_launch';
  static const String analyticsEventAppBackground = 'app_background';
  static const String analyticsEventClipboardDetect = 'clipboard_detect';
  static const String analyticsEventPreviewView = 'preview_view';

  // Privacy settings
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;

  // Update settings
  static const String updateCheckUrl =
      'https://api.github.com/repos/your-repo/instagram-downloader/releases/latest';
  static const Duration updateCheckInterval = Duration(days: 7);
  static const bool autoCheckUpdates = true;

  // Support settings
  static const String supportEmail = 'support@instagramdownloader.com';
  static const String supportWebsite = 'https://instagramdownloader.com';
  static const String privacyPolicyUrl =
      'https://instagramdownloader.com/privacy';
  static const String termsOfServiceUrl =
      'https://instagramdownloader.com/terms';

  // Social media
  static const String twitterUrl = 'https://twitter.com/instagramdownloader';
  static const String facebookUrl = 'https://facebook.com/instagramdownloader';
  static const String instagramUrl =
      'https://instagram.com/instagramdownloader';
  static const String githubUrl =
      'https://github.com/your-repo/instagram-downloader';

  // UI Constants
  static const double padding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
  static const double cardElevation = 2.0;
  static const double appBarHeight = 56.0;
  static const double bottomBarHeight = 56.0;
  static const double maxContentWidth = 600.0;
  static const double thumbnailSize = 80.0;
  static const double smallThumbnailSize = 48.0;
  static const double largeThumbnailSize = 120.0;

  // Storage constants
  static const String downloadFolderName = 'downloads';
  static const String cacheFolderName = 'cache';
  static const String thumbnailsFolderName = 'thumbnails';

  // Development settings
  static const bool enableDebugMode = true;
  static const bool enableVerboseLogging = true;
  static const bool enableMockData = false;
  static const String mockDataPath = 'assets/mock_data/';
}
