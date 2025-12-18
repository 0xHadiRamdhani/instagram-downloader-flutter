import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/logger.dart';

/// Simple download provider for managing download state
class DownloadProvider extends ChangeNotifier {
  final Map<String, DownloadState> _downloads = {};
  final Map<String, double> _downloadProgress = {};
  final Map<String, String> _downloadStatuses = {};

  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, DownloadState> get downloads => Map.unmodifiable(_downloads);
  Map<String, double> get downloadProgress =>
      Map.unmodifiable(_downloadProgress);
  Map<String, String> get downloadStatuses =>
      Map.unmodifiable(_downloadStatuses);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize download provider
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing DownloadProvider...');
      AppLogger.info('DownloadProvider initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize DownloadProvider', e);
      _error = 'Failed to initialize downloads';
      notifyListeners();
    }
  }

  /// Start download
  Future<void> startDownload({
    required String postId,
    required String mediaUrl,
    required String type,
    String? quality,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Create download ID
      final downloadId =
          '${postId}_${type}_${DateTime.now().millisecondsSinceEpoch}';

      // Add to downloads map
      _downloads[downloadId] = DownloadState(
        id: downloadId,
        postId: postId,
        mediaUrl: mediaUrl,
        type: type,
        quality: quality,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      _downloadStatuses[downloadId] = 'pending';

      AppLogger.info('Download started: $downloadId');

      // Simulate download progress
      _simulateDownloadProgress(downloadId);

      notifyListeners();
    } catch (e) {
      AppLogger.error('Failed to start download', e);
      _error = 'Failed to start download: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Simulate download progress (for demo purposes)
  void _simulateDownloadProgress(String downloadId) {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_downloads.containsKey(downloadId)) {
        timer.cancel();
        return;
      }

      final currentProgress = _downloadProgress[downloadId] ?? 0.0;
      final newProgress = (currentProgress + 0.1).clamp(0.0, 1.0);

      _downloadProgress[downloadId] = newProgress;
      _downloadStatuses[downloadId] = 'downloading';

      notifyListeners();

      if (newProgress >= 1.0) {
        timer.cancel();
        _completeDownload(downloadId);
      }
    });
  }

  /// Complete download
  void _completeDownload(String downloadId) {
    if (_downloads.containsKey(downloadId)) {
      final download = _downloads[downloadId]!;
      _downloads[downloadId] = download.copyWith(
        status: 'completed',
        completedAt: DateTime.now(),
      );
      _downloadStatuses[downloadId] = 'completed';
      _downloadProgress.remove(downloadId);

      AppLogger.info('Download completed: $downloadId');
      notifyListeners();
    }
  }

  /// Pause download
  Future<void> pauseDownload(String downloadId) async {
    try {
      if (_downloads.containsKey(downloadId)) {
        final download = _downloads[downloadId]!;
        _downloads[downloadId] = download.copyWith(status: 'paused');
        _downloadStatuses[downloadId] = 'paused';

        AppLogger.info('Download paused: $downloadId');
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to pause download', e);
      _error = 'Failed to pause download: $e';
      notifyListeners();
    }
  }

  /// Resume download
  Future<void> resumeDownload(String downloadId) async {
    try {
      if (_downloads.containsKey(downloadId)) {
        final download = _downloads[downloadId]!;
        _downloads[downloadId] = download.copyWith(status: 'downloading');
        _downloadStatuses[downloadId] = 'downloading';

        AppLogger.info('Download resumed: $downloadId');
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to resume download', e);
      _error = 'Failed to resume download: $e';
      notifyListeners();
    }
  }

  /// Cancel download
  Future<void> cancelDownload(String downloadId) async {
    try {
      // Remove from maps
      _downloads.remove(downloadId);
      _downloadProgress.remove(downloadId);
      _downloadStatuses.remove(downloadId);

      AppLogger.info('Download cancelled: $downloadId');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Failed to cancel download', e);
      _error = 'Failed to cancel download: $e';
      notifyListeners();
    }
  }

  /// Retry download
  Future<void> retryDownload(String downloadId) async {
    try {
      if (_downloads.containsKey(downloadId)) {
        final download = _downloads[downloadId]!;
        _downloads[downloadId] = download.copyWith(
          status: 'pending',
          error: null,
        );
        _downloadStatuses[downloadId] = 'pending';

        AppLogger.info('Download retried: $downloadId');
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to retry download', e);
      _error = 'Failed to retry download: $e';
      notifyListeners();
    }
  }

  /// Delete download
  Future<void> deleteDownload(String downloadId) async {
    try {
      if (_downloads.containsKey(downloadId)) {
        // Remove from maps
        _downloads.remove(downloadId);
        _downloadProgress.remove(downloadId);
        _downloadStatuses.remove(downloadId);

        AppLogger.info('Download deleted: $downloadId');
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to delete download', e);
      _error = 'Failed to delete download: $e';
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get completed downloads
  List<DownloadState> get completedDownloads {
    return _downloads.values
        .where((download) => download.status == 'completed')
        .toList()
      ..sort(
        (a, b) => (b.completedAt ?? DateTime.now()).compareTo(
          a.completedAt ?? DateTime.now(),
        ),
      );
  }

  /// Get active downloads
  List<DownloadState> get activeDownloads {
    return _downloads.values
        .where(
          (download) =>
              download.status == 'downloading' || download.status == 'pending',
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get failed downloads
  List<DownloadState> get failedDownloads {
    return _downloads.values
        .where((download) => download.status == 'failed')
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get download by ID
  DownloadState? getDownload(String downloadId) {
    return _downloads[downloadId];
  }

  /// Check if download exists
  bool hasDownload(String downloadId) {
    return _downloads.containsKey(downloadId);
  }

  /// Get download progress for specific download
  double? getProgress(String downloadId) {
    return _downloadProgress[downloadId];
  }

  /// Get download status for specific download
  String? getStatus(String downloadId) {
    return _downloadStatuses[downloadId];
  }
}

/// Simple download state class
class DownloadState {
  final String id;
  final String postId;
  final String mediaUrl;
  final String type;
  final String? quality;
  final String status;
  final String? filePath;
  final String? error;
  final DateTime createdAt;
  final DateTime? completedAt;

  DownloadState({
    required this.id,
    required this.postId,
    required this.mediaUrl,
    required this.type,
    this.quality,
    required this.status,
    this.filePath,
    this.error,
    required this.createdAt,
    this.completedAt,
  });

  /// Copy with method
  DownloadState copyWith({
    String? id,
    String? postId,
    String? mediaUrl,
    String? type,
    String? quality,
    String? status,
    String? filePath,
    String? error,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return DownloadState(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      type: type ?? this.type,
      quality: quality ?? this.quality,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'DownloadState(id: $id, postId: $postId, type: $type, status: $status)';
  }
}
