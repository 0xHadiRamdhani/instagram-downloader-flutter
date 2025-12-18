import 'package:flutter/material.dart';
import '../../../../shared/models/instagram_post.dart';
import '../../../../core/utils/logger.dart';
import '../../../../features/download/domain/entities/download_item.dart';

class PreviewProvider with ChangeNotifier {
  InstagramPost? _currentPost;
  int _selectedMediaIndex = 0;
  bool _isLoading = false;
  String? _error;
  String _selectedQuality = 'high';
  bool _isDownloadInProgress = false;
  double _downloadProgress = 0.0;

  InstagramPost? get currentPost => _currentPost;
  int get selectedMediaIndex => _selectedMediaIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedQuality => _selectedQuality;
  bool get isDownloadInProgress => _isDownloadInProgress;
  double get downloadProgress => _downloadProgress;

  void setCurrentPost(InstagramPost? post) {
    _currentPost = post;
    _selectedMediaIndex = 0;
    _error = null;
    notifyListeners();
    AppLogger.info('Current post set: ${post?.id}');
  }

  void setSelectedMediaIndex(int index) {
    if (index >= 0 && index < (_currentPost?.mediaItems.length ?? 0)) {
      _selectedMediaIndex = index;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setSelectedQuality(String quality) {
    _selectedQuality = quality;
    notifyListeners();
  }

  void setDownloadInProgress(bool inProgress) {
    _isDownloadInProgress = inProgress;
    if (!inProgress) {
      _downloadProgress = 0.0;
    }
    notifyListeners();
  }

  void setDownloadProgress(double progress) {
    _downloadProgress = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  MediaItem? get currentMediaItem {
    if (_currentPost == null || _currentPost!.mediaItems.isEmpty) return null;
    return _currentPost!.mediaItems[_selectedMediaIndex];
  }

  bool get hasMultipleMedia {
    return (_currentPost?.mediaItems.length ?? 0) > 1;
  }

  String get postTypeDisplay {
    if (_currentPost == null) return '';
    return _currentPost!.type.displayName;
  }

  String get postTypeIcon {
    if (_currentPost == null) return '';
    return _currentPost!.type.icon;
  }

  String get formattedCaption {
    if (_currentPost?.caption == null || _currentPost!.caption!.isEmpty) {
      return 'No caption available';
    }

    // Truncate caption if too long
    final caption = _currentPost!.caption!;
    if (caption.length > 200) {
      return '${caption.substring(0, 200)}...';
    }
    return caption;
  }

  String get formattedUsername {
    if (_currentPost == null) return '';
    return '@${_currentPost!.username}';
  }

  String get formattedDate {
    if (_currentPost == null) return '';

    final now = DateTime.now();
    final postDate = _currentPost!.createdAt;
    final difference = now.difference(postDate);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get formattedStats {
    if (_currentPost == null) return '';

    final likes = _currentPost!.likeCount ?? 0;
    final comments = _currentPost!.commentCount ?? 0;

    return '${_formatNumber(likes)} likes • ${_formatNumber(comments)} comments';
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Future<void> downloadContent() async {
    if (_currentPost == null) {
      setError('No content to download');
      return;
    }

    try {
      setDownloadInProgress(true);
      setError(null);

      AppLogger.info('Starting download for post: ${_currentPost!.id}');

      // TODO: Implement actual download logic
      // For now, we'll simulate a download

      // Simulate download progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        setDownloadProgress(i / 100);
      }

      // Create download item
      final downloadItem = DownloadItem(
        id: 'download_${DateTime.now().millisecondsSinceEpoch}',
        post: _currentPost!,
        status: DownloadStatus.completed,
        progress: 1.0,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
        type: _getDownloadType(),
        fileName:
            '${_currentPost!.id}_${_selectedQuality}_$_selectedMediaIndex',
      );

      AppLogger.info('Download completed successfully');

      // TODO: Save to history and storage
    } catch (e) {
      setError('Download failed: ${e.toString()}');
      AppLogger.error('Download failed', e);
    } finally {
      setDownloadInProgress(false);
    }
  }

  DownloadType _getDownloadType() {
    if (_currentPost == null) return DownloadType.image;

    switch (_currentPost!.type) {
      case PostType.post:
      case PostType.carousel:
        return DownloadType.image;
      case PostType.reel:
      case PostType.tv:
        return DownloadType.video;
      case PostType.story:
        return DownloadType.story;
    }
  }

  void clearError() {
    setError(null);
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
