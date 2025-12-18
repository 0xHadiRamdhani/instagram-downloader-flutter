import 'dart:async';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../features/download/domain/entities/download_item.dart';
import '../models/instagram_post.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  // Download queue management
  final Map<String, DownloadItem> _downloadQueue = {};
  final StreamController<DownloadItem> _downloadStreamController =
      StreamController<DownloadItem>.broadcast();
  final StreamController<DownloadProgress> _progressStreamController =
      StreamController<DownloadProgress>.broadcast();

  // Streams for UI updates
  Stream<DownloadItem> get downloadStream => _downloadStreamController.stream;
  Stream<DownloadProgress> get progressStream =>
      _progressStreamController.stream;

  // Initialize download service
  Future<void> initialize() async {
    try {
      await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
      AppLogger.info('DownloadService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize DownloadService', e);
      rethrow;
    }
  }

  // Request storage permissions
  Future<bool> requestPermissions() async {
    try {
      // For Android 13+ (API 33+)
      if (Platform.isAndroid) {
        final photosStatus = await Permission.photos.request();
        final videosStatus = await Permission.videos.request();
        if (photosStatus.isGranted && videosStatus.isGranted) {
          return true;
        }
      }

      // For older Android versions and iOS
      final storageStatus = await Permission.storage.request();
      final mediaStatus = await Permission.mediaLibrary.request();

      return storageStatus.isGranted && mediaStatus.isGranted;
    } catch (e) {
      AppLogger.error('Permission request failed', e);
      return false;
    }
  }

  // Check if permissions are granted
  Future<bool> checkPermissions() async {
    try {
      // For Android 13+ (API 33+)
      if (Platform.isAndroid) {
        final photosGranted = await Permission.photos.isGranted;
        final videosGranted = await Permission.videos.isGranted;
        if (photosGranted && videosGranted) {
          return true;
        }
      }

      // For older versions
      final storageGranted = await Permission.storage.isGranted;
      final mediaGranted = await Permission.mediaLibrary.isGranted;

      return storageGranted && mediaGranted;
    } catch (e) {
      AppLogger.error('Permission check failed', e);
      return false;
    }
  }

  // Start download process
  Future<DownloadItem?> startDownload({
    required InstagramPost post,
    required String quality,
    int mediaIndex = 0,
  }) async {
    try {
      // Check permissions first
      if (!await checkPermissions()) {
        final hasPermission = await requestPermissions();
        if (!hasPermission) {
          throw DownloadException(
            'Storage permission denied',
            DownloadErrorType.permissionDenied,
          );
        }
      }

      // Validate input
      if (mediaIndex < 0 || mediaIndex >= post.mediaItems.length) {
        throw DownloadException(
          'Invalid media index',
          DownloadErrorType.invalidInput,
        );
      }

      final mediaItem = post.mediaItems[mediaIndex];
      final downloadId = 'download_${DateTime.now().millisecondsSinceEpoch}';

      // Create download directory
      final downloadDir = await _getDownloadDirectory();
      final fileName = _generateFileName(post, mediaItem, quality);
      final filePath = '$downloadDir/$fileName';

      // Create download item
      final downloadItem = DownloadItem(
        id: downloadId,
        post: post,
        status: DownloadStatus.pending,
        progress: 0.0,
        createdAt: DateTime.now(),
        type: _getDownloadType(mediaItem.type),
        fileName: fileName,
      );

      // Add to queue
      _downloadQueue[downloadId] = downloadItem;

      // Start actual download
      await _performDownload(downloadItem, mediaItem.url, filePath);

      AppLogger.info('Download started: $downloadId');
      return downloadItem;
    } catch (e) {
      AppLogger.error('Download start failed', e);
      if (e is DownloadException) {
        rethrow;
      }
      throw DownloadException(
        'Failed to start download: ${e.toString()}',
        DownloadErrorType.unknown,
      );
    }
  }

  // Perform actual download
  Future<void> _performDownload(
    DownloadItem item,
    String url,
    String filePath,
  ) async {
    try {
      // Update status to downloading
      _updateDownloadStatus(item, DownloadStatus.downloading);

      // Create download task
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: filePath.substring(0, filePath.lastIndexOf('/')),
        fileName: filePath.split('/').last,
        showNotification: true,
        openFileFromNotification: true,
        headers: {'User-Agent': 'InstagramDownloader/1.0', 'Accept': '*/*'},
      );

      if (taskId == null) {
        throw DownloadException(
          'Failed to create download task',
          DownloadErrorType.taskCreationFailed,
        );
      }

      // Monitor download progress
      _monitorDownloadProgress(taskId, item);
    } catch (e) {
      AppLogger.error('Download perform failed', e);
      _updateDownloadStatus(item, DownloadStatus.failed, error: e.toString());
      rethrow;
    }
  }

  // Monitor download progress
  void _monitorDownloadProgress(String taskId, DownloadItem item) {
    FlutterDownloader.registerCallback((id, status, progress) {
      if (id == taskId) {
        _handleDownloadCallback(id, status, progress, item);
      }
    });
  }

  // Handle download callback
  void _handleDownloadCallback(
    String id,
    int status,
    int progress,
    DownloadItem item,
  ) {
    try {
      final downloadStatus = _mapDownloadStatus(status);
      final progressValue = progress / 100;

      // Update progress
      _updateDownloadProgress(item, progressValue);

      // Handle status changes
      switch (downloadStatus) {
        case DownloadStatus.completed:
          _handleDownloadCompleted(item);
          break;
        case DownloadStatus.failed:
          _handleDownloadFailed(item, 'Download failed');
          break;
        case DownloadStatus.cancelled:
          _handleDownloadCancelled(item);
          break;
        case DownloadStatus.paused:
          _updateDownloadStatus(item, DownloadStatus.paused);
          break;
        default:
          _updateDownloadStatus(item, DownloadStatus.downloading);
      }
    } catch (e) {
      AppLogger.error('Download callback handling failed', e);
      _handleDownloadFailed(item, 'Callback error: ${e.toString()}');
    }
  }

  // Handle download completion
  Future<void> _handleDownloadCompleted(DownloadItem item) async {
    try {
      _updateDownloadStatus(item, DownloadStatus.completed);

      // Update completion time
      final updatedItem = item.copyWith(
        completedAt: DateTime.now(),
        progress: 1.0,
      );

      _downloadQueue[item.id] = updatedItem;
      _downloadStreamController.add(updatedItem);

      AppLogger.info('Download completed: ${item.id}');

      // Save to history (TODO: Implement history service)
      // await _saveToHistory(updatedItem);
    } catch (e) {
      AppLogger.error('Download completion handling failed', e);
      _handleDownloadFailed(item, 'Completion error: ${e.toString()}');
    }
  }

  // Handle download failure
  void _handleDownloadFailed(DownloadItem item, String error) {
    _updateDownloadStatus(item, DownloadStatus.failed, error: error);
    AppLogger.error('Download failed: ${item.id}, Error: $error');
  }

  // Handle download cancellation
  void _handleDownloadCancelled(DownloadItem item) {
    _updateDownloadStatus(item, DownloadStatus.cancelled);
    AppLogger.info('Download cancelled: ${item.id}');
  }

  // Update download status
  void _updateDownloadStatus(
    DownloadItem item,
    DownloadStatus status, {
    String? error,
  }) {
    final updatedItem = item.copyWith(
      status: status,
      errorMessage: error ?? item.errorMessage,
    );

    _downloadQueue[item.id] = updatedItem;
    _downloadStreamController.add(updatedItem);

    // Broadcast progress update
    _progressStreamController.add(
      DownloadProgress(
        downloadId: item.id,
        progress: item.progress,
        status: status,
        error: error,
      ),
    );
  }

  // Update download progress
  void _updateDownloadProgress(DownloadItem item, double progress) {
    final updatedItem = item.copyWith(progress: progress);
    _downloadQueue[item.id] = updatedItem;

    _progressStreamController.add(
      DownloadProgress(
        downloadId: item.id,
        progress: progress,
        status: item.status,
      ),
    );
  }

  // Cancel download
  Future<void> cancelDownload(String downloadId) async {
    try {
      final item = _downloadQueue[downloadId];
      if (item != null && item.status == DownloadStatus.downloading) {
        // TODO: Implement actual download cancellation with FlutterDownloader
        _handleDownloadCancelled(item);
        AppLogger.info('Download cancelled: $downloadId');
      }
    } catch (e) {
      AppLogger.error('Download cancellation failed', e);
      throw DownloadException(
        'Failed to cancel download: ${e.toString()}',
        DownloadErrorType.cancellationFailed,
      );
    }
  }

  // Retry download
  Future<void> retryDownload(String downloadId) async {
    try {
      final item = _downloadQueue[downloadId];
      if (item != null &&
          (item.status == DownloadStatus.failed ||
              item.status == DownloadStatus.cancelled)) {
        // Reset status and retry
        _updateDownloadStatus(item, DownloadStatus.pending);

        // Get media URL and retry
        final mediaItem = item.post.mediaItems.first;
        final downloadDir = await _getDownloadDirectory();
        final filePath = '$downloadDir/${item.fileName}';

        await _performDownload(item, mediaItem.url, filePath);

        AppLogger.info('Download retried: $downloadId');
      }
    } catch (e) {
      AppLogger.error('Download retry failed', e);
      throw DownloadException(
        'Failed to retry download: ${e.toString()}',
        DownloadErrorType.retryFailed,
      );
    }
  }

  // Get download directory
  Future<String> _getDownloadDirectory() async {
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        // Use external storage for Android
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadDir = Directory(
            '${directory.path}/${AppConstants.downloadFolderName}',
          );
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir.path;
        }
      } else if (Platform.isIOS) {
        // Use documents directory for iOS
        directory = await getApplicationDocumentsDirectory();
        if (directory != null) {
          final downloadDir = Directory(
            '${directory.path}/${AppConstants.downloadFolderName}',
          );
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir.path;
        }
      }

      // Fallback to temporary directory
      directory = await getTemporaryDirectory();
      return directory.path;
    } catch (e) {
      AppLogger.error('Failed to get download directory', e);
      throw DownloadException(
        'Failed to get download directory: ${e.toString()}',
        DownloadErrorType.directoryAccessFailed,
      );
    }
  }

  // Generate file name
  String _generateFileName(
    InstagramPost post,
    MediaItem media,
    String quality,
  ) {
    final extension = media.type.fileExtension;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final qualitySuffix = quality != 'high' ? '_$quality' : '';

    return '${post.username}_${post.id}_$timestamp$qualitySuffix$extension';
  }

  // Map download status
  DownloadStatus _mapDownloadStatus(int status) {
    switch (status) {
      case 1: // enqueued
        return DownloadStatus.pending;
      case 2: // running
        return DownloadStatus.downloading;
      case 3: // complete
        return DownloadStatus.completed;
      case 4: // failed
        return DownloadStatus.failed;
      case 5: // canceled
        return DownloadStatus.cancelled;
      case 6: // paused
        return DownloadStatus.paused;
      default:
        return DownloadStatus.pending;
    }
  }

  // Get download type
  DownloadType _getDownloadType(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.image:
        return DownloadType.image;
      case MediaType.video:
        return DownloadType.video;
      case MediaType.carousel:
        return DownloadType.carousel;
    }
  }

  // Get all downloads
  List<DownloadItem> getAllDownloads() {
    return _downloadQueue.values.toList();
  }

  // Get download by ID
  DownloadItem? getDownload(String downloadId) {
    return _downloadQueue[downloadId];
  }

  // Clear completed downloads
  void clearCompletedDownloads() {
    _downloadQueue.removeWhere(
      (id, item) =>
          item.status == DownloadStatus.completed ||
          item.status == DownloadStatus.failed ||
          item.status == DownloadStatus.cancelled,
    );
  }

  // Dispose resources
  void dispose() {
    _downloadStreamController.close();
    _progressStreamController.close();
    // Don't unregister callback as it might affect other downloads
  }
}

// Download progress model
class DownloadProgress {
  final String downloadId;
  final double progress;
  final DownloadStatus status;
  final String? error;

  DownloadProgress({
    required this.downloadId,
    required this.progress,
    required this.status,
    this.error,
  });
}

// Custom download exception
class DownloadException implements Exception {
  final String message;
  final DownloadErrorType errorType;

  DownloadException(this.message, this.errorType);

  @override
  String toString() => 'DownloadException: $message (Type: $errorType)';
}

// Download error types
enum DownloadErrorType {
  permissionDenied,
  invalidInput,
  taskCreationFailed,
  networkError,
  storageError,
  directoryAccessFailed,
  cancellationFailed,
  retryFailed,
  unknown,
}
