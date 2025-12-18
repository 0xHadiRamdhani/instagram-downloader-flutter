import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      AppLogger.info('StorageService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize StorageService', e);
      rethrow;
    }
  }

  static Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      AppLogger.error('Failed to set string for key: $key', e);
      return false;
    }
  }

  static String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      AppLogger.error('Failed to get string for key: $key', e);
      return null;
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      AppLogger.error('Failed to set bool for key: $key', e);
      return false;
    }
  }

  static bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      AppLogger.error('Failed to get bool for key: $key', e);
      return null;
    }
  }

  static Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      AppLogger.error('Failed to set int for key: $key', e);
      return false;
    }
  }

  static int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      AppLogger.error('Failed to get int for key: $key', e);
      return null;
    }
  }

  static Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      AppLogger.error('Failed to set double for key: $key', e);
      return false;
    }
  }

  static double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      AppLogger.error('Failed to get double for key: $key', e);
      return null;
    }
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      AppLogger.error('Failed to set string list for key: $key', e);
      return false;
    }
  }

  static List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      AppLogger.error('Failed to get string list for key: $key', e);
      return null;
    }
  }

  static Future<bool> setObject(String key, dynamic value) async {
    try {
      return await _prefs.setString(key, jsonEncode(value));
    } catch (e) {
      AppLogger.error('Failed to set object for key: $key', e);
      return false;
    }
  }

  static dynamic getObject(String key) {
    try {
      final String? data = _prefs.getString(key);
      return data != null ? jsonDecode(data) : null;
    } catch (e) {
      AppLogger.error('Failed to get object for key: $key', e);
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      AppLogger.error('Failed to remove key: $key', e);
      return false;
    }
  }

  static Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      AppLogger.error('Failed to clear storage', e);
      return false;
    }
  }

  static Set<String> getKeys() {
    try {
      return _prefs.getKeys();
    } catch (e) {
      AppLogger.error('Failed to get keys', e);
      return {};
    }
  }

  static bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      AppLogger.error('Failed to check if key exists: $key', e);
      return false;
    }
  }
}

// Storage keys
class StorageKeys {
  static const String isFirstLaunch = 'is_first_launch';
  static const String darkMode = 'dark_mode';
  static const String downloadQuality = 'download_quality';
  static const String autoDownloadClipboard = 'auto_download_clipboard';
  static const String downloadHistory = 'download_history';
  static const String lastClipboardUrl = 'last_clipboard_url';
  static const String tutorialCompleted = 'tutorial_completed';
  static const String appLanguage = 'app_language';
  static const String downloadFolder = 'download_folder';
  static const String maxConcurrentDownloads = 'max_concurrent_downloads';
  static const String wifiOnlyDownloads = 'wifi_only_downloads';
  static const String showNotifications = 'show_notifications';
  static const String downloadPath = 'download_path';
}
