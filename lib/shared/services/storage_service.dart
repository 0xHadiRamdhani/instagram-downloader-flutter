import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';
import '../../core/constants/app_constants.dart';

/// Storage service for managing app data persistence
/// Handles both file system and shared preferences storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  Directory? _appDocDir;
  Directory? _downloadsDir;
  Directory? _tempDir;

  /// Initialize storage service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing StorageService...');

      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Initialize directories
      _appDocDir = await getApplicationDocumentsDirectory();
      _downloadsDir = await getDownloadsDirectory();
      _tempDir = await getTemporaryDirectory();

      // Create app-specific directories if they don't exist
      await _createAppDirectories();

      AppLogger.info('StorageService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize StorageService', e);
      rethrow;
    }
  }

  /// Create app-specific directories
  Future<void> _createAppDirectories() async {
    try {
      // Create downloads directory in app documents
      final appDownloadsDir = Directory('${_appDocDir!.path}/downloads');
      if (!await appDownloadsDir.exists()) {
        await appDownloadsDir.create(recursive: true);
        AppLogger.info('Created downloads directory: ${appDownloadsDir.path}');
      }

      // Create cache directory for temporary files
      final cacheDir = Directory('${_tempDir!.path}/cache');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
        AppLogger.info('Created cache directory: ${cacheDir.path}');
      }

      // Create thumbnails directory
      final thumbnailsDir = Directory('${_tempDir!.path}/thumbnails');
      if (!await thumbnailsDir.exists()) {
        await thumbnailsDir.create(recursive: true);
        AppLogger.info('Created thumbnails directory: ${thumbnailsDir.path}');
      }
    } catch (e) {
      AppLogger.error('Failed to create app directories', e);
      rethrow;
    }
  }

  /// Get app documents directory
  Directory get appDocumentsDirectory {
    if (_appDocDir == null) {
      throw Exception('StorageService not initialized');
    }
    return _appDocDir!;
  }

  /// Get downloads directory
  Directory get downloadsDirectory {
    if (_downloadsDir == null) {
      throw Exception('StorageService not initialized');
    }
    return _downloadsDir!;
  }

  /// Get temporary directory
  Directory get temporaryDirectory {
    if (_tempDir == null) {
      throw Exception('StorageService not initialized');
    }
    return _tempDir!;
  }

  /// Get app-specific downloads directory
  Directory get appDownloadsDirectory {
    if (_appDocDir == null) {
      throw Exception('StorageService not initialized');
    }
    return Directory('${_appDocDir!.path}/downloads');
  }

  /// Get cache directory
  Directory get cacheDirectory {
    if (_tempDir == null) {
      throw Exception('StorageService not initialized');
    }
    return Directory('${_tempDir!.path}/cache');
  }

  /// Get thumbnails directory
  Directory get thumbnailsDirectory {
    if (_tempDir == null) {
      throw Exception('StorageService not initialized');
    }
    return Directory('${_tempDir!.path}/thumbnails');
  }

  /// Save string to SharedPreferences
  Future<bool> saveString(String key, String value) async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.setString(key, value);
      AppLogger.info('Saved string to preferences: $key');
      return result;
    } catch (e) {
      AppLogger.error('Failed to save string: $key', e);
      return false;
    }
  }

  /// Get string from SharedPreferences
  String? getString(String key) {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final value = _prefs!.getString(key);
      AppLogger.info('Retrieved string from preferences: $key');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get string: $key', e);
      return null;
    }
  }

  /// Save boolean to SharedPreferences
  Future<bool> saveBool(String key, bool value) async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.setBool(key, value);
      AppLogger.info('Saved boolean to preferences: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to save boolean: $key', e);
      return false;
    }
  }

  /// Get boolean from SharedPreferences
  bool? getBool(String key) {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final value = _prefs!.getBool(key);
      AppLogger.info('Retrieved boolean from preferences: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get boolean: $key', e);
      return null;
    }
  }

  /// Save integer to SharedPreferences
  Future<bool> saveInt(String key, int value) async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.setInt(key, value);
      AppLogger.info('Saved integer to preferences: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to save integer: $key', e);
      return false;
    }
  }

  /// Get integer from SharedPreferences
  int? getInt(String key) {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final value = _prefs!.getInt(key);
      AppLogger.info('Retrieved integer from preferences: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get integer: $key', e);
      return null;
    }
  }

  /// Save double to SharedPreferences
  Future<bool> saveDouble(String key, double value) async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.setDouble(key, value);
      AppLogger.info('Saved double to preferences: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to save double: $key', e);
      return false;
    }
  }

  /// Get double from SharedPreferences
  double? getDouble(String key) {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final value = _prefs!.getDouble(key);
      AppLogger.info('Retrieved double from preferences: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get double: $key', e);
      return null;
    }
  }

  /// Save string list to SharedPreferences
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.setStringList(key, value);
      AppLogger.info(
        'Saved string list to preferences: $key (${value.length} items)',
      );
      return result;
    } catch (e) {
      AppLogger.error('Failed to save string list: $key', e);
      return false;
    }
  }

  /// Get string list from SharedPreferences
  List<String>? getStringList(String key) {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final value = _prefs!.getStringList(key);
      AppLogger.info(
        'Retrieved string list from preferences: $key (${value?.length ?? 0} items)',
      );
      return value;
    } catch (e) {
      AppLogger.error('Failed to get string list: $key', e);
      return null;
    }
  }

  /// Save object as JSON to SharedPreferences
  Future<bool> saveObject(String key, Map<String, dynamic> object) async {
    try {
      final jsonString = jsonEncode(object);
      return await saveString(key, jsonString);
    } catch (e) {
      AppLogger.error('Failed to save object: $key', e);
      return false;
    }
  }

  /// Get object from JSON in SharedPreferences
  Map<String, dynamic>? getObject(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to get object: $key', e);
      return null;
    }
  }

  /// Remove key from SharedPreferences
  Future<bool> remove(String key) async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.remove(key);
      AppLogger.info('Removed from preferences: $key');
      return result;
    } catch (e) {
      AppLogger.error('Failed to remove: $key', e);
      return false;
    }
  }

  /// Clear all SharedPreferences
  Future<bool> clear() async {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      final result = await _prefs!.clear();
      AppLogger.info('Cleared all preferences');
      return result;
    } catch (e) {
      AppLogger.error('Failed to clear preferences', e);
      return false;
    }
  }

  /// Check if key exists in SharedPreferences
  bool containsKey(String key) {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      return _prefs!.containsKey(key);
    } catch (e) {
      AppLogger.error('Failed to check if key exists: $key', e);
      return false;
    }
  }

  /// Get all keys from SharedPreferences
  Set<String> getKeys() {
    try {
      if (_prefs == null) {
        throw Exception('StorageService not initialized');
      }

      return _prefs!.getKeys();
    } catch (e) {
      AppLogger.error('Failed to get keys', e);
      return {};
    }
  }

  /// Save file to app documents directory
  Future<File?> saveFile(
    String fileName,
    List<int> bytes, {
    String? subDirectory,
  }) async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final directory = subDirectory != null
          ? Directory('${_appDocDir!.path}/$subDirectory')
          : _appDocDir!;

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);

      AppLogger.info('Saved file: ${file.path}');
      return file;
    } catch (e) {
      AppLogger.error('Failed to save file: $fileName', e);
      return null;
    }
  }

  /// Read file from app documents directory
  Future<List<int>?> readFile(String fileName, {String? subDirectory}) async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final directory = subDirectory != null
          ? Directory('${_appDocDir!.path}/$subDirectory')
          : _appDocDir!;

      final file = File('${directory.path}/$fileName');

      if (!await file.exists()) {
        AppLogger.warning('File not found: ${file.path}');
        return null;
      }

      final bytes = await file.readAsBytes();
      AppLogger.info('Read file: ${file.path}');
      return bytes;
    } catch (e) {
      AppLogger.error('Failed to read file: $fileName', e);
      return null;
    }
  }

  /// Delete file from app documents directory
  Future<bool> deleteFile(String fileName, {String? subDirectory}) async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final directory = subDirectory != null
          ? Directory('${_appDocDir!.path}/$subDirectory')
          : _appDocDir!;

      final file = File('${directory.path}/$fileName');

      if (!await file.exists()) {
        AppLogger.warning('File not found for deletion: ${file.path}');
        return false;
      }

      await file.delete();
      AppLogger.info('Deleted file: ${file.path}');
      return true;
    } catch (e) {
      AppLogger.error('Failed to delete file: $fileName', e);
      return false;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String fileName, {String? subDirectory}) async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final directory = subDirectory != null
          ? Directory('${_appDocDir!.path}/$subDirectory')
          : _appDocDir!;

      final file = File('${directory.path}/$fileName');
      return await file.exists();
    } catch (e) {
      AppLogger.error('Failed to check if file exists: $fileName', e);
      return false;
    }
  }

  /// Get file size in bytes
  Future<int?> getFileSize(String fileName, {String? subDirectory}) async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final directory = subDirectory != null
          ? Directory('${_appDocDir!.path}/$subDirectory')
          : _appDocDir!;

      final file = File('${directory.path}/$fileName');

      if (!await file.exists()) {
        return null;
      }

      final stat = await file.stat();
      return stat.size;
    } catch (e) {
      AppLogger.error('Failed to get file size: $fileName', e);
      return null;
    }
  }

  /// Get available storage space in bytes
  Future<int?> getAvailableStorageSpace() async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final stat = await _appDocDir!.stat();
      // This is a simplified calculation - in production you might want to use
      // platform-specific methods to get accurate available space
      return stat.size;
    } catch (e) {
      AppLogger.error('Failed to get available storage space', e);
      return null;
    }
  }

  /// Clean up temporary files
  Future<void> cleanupTempFiles() async {
    try {
      if (_tempDir == null) {
        throw Exception('StorageService not initialized');
      }

      final cacheDir = Directory('${_tempDir!.path}/cache');
      final thumbnailsDir = Directory('${_tempDir!.path}/thumbnails');

      // Clean cache directory
      if (await cacheDir.exists()) {
        final cacheFiles = cacheDir.listSync();
        for (final file in cacheFiles) {
          if (file is File) {
            await file.delete();
          }
        }
        AppLogger.info('Cleaned cache directory');
      }

      // Clean thumbnails directory
      if (await thumbnailsDir.exists()) {
        final thumbnailFiles = thumbnailsDir.listSync();
        for (final file in thumbnailFiles) {
          if (file is File) {
            await file.delete();
          }
        }
        AppLogger.info('Cleaned thumbnails directory');
      }
    } catch (e) {
      AppLogger.error('Failed to cleanup temporary files', e);
    }
  }

  /// Get storage usage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      if (_appDocDir == null) {
        throw Exception('StorageService not initialized');
      }

      final downloadsDir = appDownloadsDirectory;
      final cacheDir = cacheDirectory;
      final thumbnailsDir = thumbnailsDirectory;

      int downloadsSize = 0;
      int cacheSize = 0;
      int thumbnailsSize = 0;

      // Calculate downloads size
      if (await downloadsDir.exists()) {
        final downloadsFiles = downloadsDir.listSync();
        for (final file in downloadsFiles) {
          if (file is File) {
            final stat = await file.stat();
            downloadsSize += stat.size;
          }
        }
      }

      // Calculate cache size
      if (await cacheDir.exists()) {
        final cacheFiles = cacheDir.listSync();
        for (final file in cacheFiles) {
          if (file is File) {
            final stat = await file.stat();
            cacheSize += stat.size;
          }
        }
      }

      // Calculate thumbnails size
      if (await thumbnailsDir.exists()) {
        final thumbnailFiles = thumbnailsDir.listSync();
        for (final file in thumbnailFiles) {
          if (file is File) {
            final stat = await file.stat();
            thumbnailsSize += stat.size;
          }
        }
      }

      return {
        'downloadsSize': downloadsSize,
        'cacheSize': cacheSize,
        'thumbnailsSize': thumbnailsSize,
        'totalSize': downloadsSize + cacheSize + thumbnailsSize,
      };
    } catch (e) {
      AppLogger.error('Failed to get storage stats', e);
      return {};
    }
  }
}
