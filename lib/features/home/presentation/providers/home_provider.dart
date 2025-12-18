import 'package:flutter/material.dart';
import '../../../../shared/services/clipboard_service.dart';
import '../../../../shared/models/instagram_post.dart';
import '../../../../core/utils/logger.dart';

class HomeProvider with ChangeNotifier {
  String _urlInput = '';
  String? _clipboardUrl;
  bool _isLoading = false;
  String? _error;
  InstagramPost? _currentPost;
  bool _isClipboardMonitoring = false;

  String get urlInput => _urlInput;
  String? get clipboardUrl => _clipboardUrl;
  bool get isLoading => _isLoading;
  String? get error => _error;
  InstagramPost? get currentPost => _currentPost;
  bool get isClipboardMonitoring => _isClipboardMonitoring;

  void setUrlInput(String url) {
    _urlInput = url.trim();
    _error = null;
    notifyListeners();
  }

  void clearUrlInput() {
    _urlInput = '';
    _error = null;
    notifyListeners();
  }

  void setClipboardUrl(String? url) {
    _clipboardUrl = url;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setCurrentPost(InstagramPost? post) {
    _currentPost = post;
    notifyListeners();
  }

  bool isValidInstagramUrl(String url) {
    return ClipboardService.isInstagramUrl(url);
  }

  String? extractPostId(String url) {
    return ClipboardService.extractInstagramPostId(url);
  }

  InstagramContentType? getContentType(String url) {
    return ClipboardService.getContentType(url);
  }

  Future<void> checkClipboard() async {
    try {
      final clipboardText = await ClipboardService.getClipboardText();

      if (clipboardText.isNotEmpty &&
          ClipboardService.isInstagramUrl(clipboardText) &&
          clipboardText != _clipboardUrl) {
        setClipboardUrl(clipboardText);
        AppLogger.info('Instagram URL detected in clipboard: $clipboardText');
      }
    } catch (e) {
      AppLogger.error('Error checking clipboard', e);
    }
  }

  void startClipboardMonitoring() {
    if (!_isClipboardMonitoring) {
      ClipboardService.startClipboardMonitoring();
      _isClipboardMonitoring = true;

      // Listen to clipboard stream
      ClipboardService.clipboardStream.listen((url) {
        setClipboardUrl(url);
      });

      AppLogger.info('Clipboard monitoring started');
      notifyListeners();
    }
  }

  void stopClipboardMonitoring() {
    if (_isClipboardMonitoring) {
      ClipboardService.stopClipboardMonitoring();
      _isClipboardMonitoring = false;
      AppLogger.info('Clipboard monitoring stopped');
      notifyListeners();
    }
  }

  Future<void> processUrl(String url) async {
    try {
      setLoading(true);
      setError(null);

      if (url.isEmpty) {
        setError('Please enter an Instagram URL');
        setLoading(false);
        return;
      }

      if (!isValidInstagramUrl(url)) {
        setError('Please enter a valid Instagram URL');
        setLoading(false);
        return;
      }

      final postId = extractPostId(url);
      if (postId == null) {
        setError('Could not extract post ID from URL');
        setLoading(false);
        return;
      }

      final contentType = getContentType(url);
      AppLogger.info(
        'Processing Instagram URL: $url (Type: ${contentType?.displayName})',
      );

      // TODO: Implement actual Instagram data fetching
      // For now, we'll create a mock post
      final mockPost = InstagramPost(
        id: postId,
        url: url,
        username: 'instagram_user',
        displayName: 'Instagram User',
        caption: 'This is a sample caption for the Instagram post',
        profilePictureUrl: 'https://via.placeholder.com/150',
        mediaItems: [
          MediaItem(
            id: '${postId}_1',
            url: 'https://via.placeholder.com/600',
            type: MediaType.image,
            width: 600,
            height: 600,
            quality: 'high',
          ),
        ],
        createdAt: DateTime.now(),
        type: PostType.post,
        likeCount: 1000,
        commentCount: 50,
        isVerified: false,
      );

      setCurrentPost(mockPost);
      AppLogger.info('Successfully processed Instagram post: $postId');
    } catch (e) {
      setError('Failed to process Instagram URL: ${e.toString()}');
      AppLogger.error('Error processing Instagram URL', e);
    } finally {
      setLoading(false);
    }
  }

  void useClipboardUrl() {
    if (_clipboardUrl != null) {
      setUrlInput(_clipboardUrl!);
      setClipboardUrl(null);
    }
  }

  void clearError() {
    setError(null);
  }

  @override
  void dispose() {
    stopClipboardMonitoring();
    super.dispose();
  }
}
