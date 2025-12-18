import 'dart:async';
import 'package:clipboard/clipboard.dart';
import '../../core/utils/logger.dart';

class ClipboardService {
  static Timer? _clipboardTimer;
  static String? _lastClipboardText;
  static final StreamController<String> _clipboardStreamController =
      StreamController<String>.broadcast();

  static Stream<String> get clipboardStream =>
      _clipboardStreamController.stream;

  static Future<String> getClipboardText() async {
    try {
      return await FlutterClipboard.paste();
    } catch (e) {
      AppLogger.error('Failed to get clipboard text', e);
      return '';
    }
  }

  static Future<void> copyToClipboard(String text) async {
    try {
      await FlutterClipboard.copy(text);
      AppLogger.info('Text copied to clipboard');
    } catch (e) {
      AppLogger.error('Failed to copy text to clipboard', e);
    }
  }

  static bool isInstagramUrl(String text) {
    if (text.isEmpty) return false;

    final instagramRegex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?instagram\.com\/(p|reel|tv|stories)\/([a-zA-Z0-9_-]+)',
      caseSensitive: false,
    );

    return instagramRegex.hasMatch(text.trim());
  }

  static String? extractInstagramPostId(String url) {
    if (url.isEmpty) return null;

    final instagramRegex = RegExp(
      r'instagram\.com\/(?:p|reel|tv|stories)\/([a-zA-Z0-9_-]+)',
      caseSensitive: false,
    );

    final match = instagramRegex.firstMatch(url.trim());
    return match?.group(1);
  }

  static String? extractInstagramUsername(String url) {
    if (url.isEmpty) return null;

    final usernameRegex = RegExp(
      r'instagram\.com\/([a-zA-Z0-9_.]+)\/?',
      caseSensitive: false,
    );

    final match = usernameRegex.firstMatch(url.trim());
    final username = match?.group(1);

    // Filter out known Instagram paths
    if (username != null &&
        ![
          'p',
          'reel',
          'tv',
          'stories',
          'explore',
          'accounts',
        ].contains(username)) {
      return username;
    }

    return null;
  }

  static InstagramContentType? getContentType(String url) {
    if (url.isEmpty) return null;

    final urlLower = url.toLowerCase();

    if (urlLower.contains('/p/')) {
      return InstagramContentType.post;
    } else if (urlLower.contains('/reel/')) {
      return InstagramContentType.reel;
    } else if (urlLower.contains('/tv/')) {
      return InstagramContentType.tv;
    } else if (urlLower.contains('/stories/')) {
      return InstagramContentType.story;
    }

    return null;
  }

  static void startClipboardMonitoring() {
    _clipboardTimer?.cancel();
    _clipboardTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkClipboard();
    });
    AppLogger.info('Clipboard monitoring started');
  }

  static void stopClipboardMonitoring() {
    _clipboardTimer?.cancel();
    _clipboardTimer = null;
    AppLogger.info('Clipboard monitoring stopped');
  }

  static Future<void> _checkClipboard() async {
    try {
      final currentClipboard = await getClipboardText();

      if (currentClipboard.isNotEmpty &&
          currentClipboard != _lastClipboardText &&
          isInstagramUrl(currentClipboard)) {
        _lastClipboardText = currentClipboard;
        _clipboardStreamController.add(currentClipboard);
        AppLogger.info(
          'Instagram URL detected in clipboard: $currentClipboard',
        );
      }
    } catch (e) {
      AppLogger.error('Error checking clipboard', e);
    }
  }

  static void dispose() {
    _clipboardTimer?.cancel();
    _clipboardStreamController.close();
  }
}

enum InstagramContentType { post, reel, tv, story }

extension InstagramContentTypeExtension on InstagramContentType {
  String get displayName {
    switch (this) {
      case InstagramContentType.post:
        return 'Post';
      case InstagramContentType.reel:
        return 'Reel';
      case InstagramContentType.tv:
        return 'IGTV';
      case InstagramContentType.story:
        return 'Story';
    }
  }

  String get icon {
    switch (this) {
      case InstagramContentType.post:
        return '📷';
      case InstagramContentType.reel:
        return '🎬';
      case InstagramContentType.tv:
        return '📺';
      case InstagramContentType.story:
        return '💫';
    }
  }
}
