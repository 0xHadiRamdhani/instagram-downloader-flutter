import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram_downloader/shared/services/storage_service.dart';
import 'package:instagram_downloader/core/utils/logger.dart';

class GalleryProvider extends ChangeNotifier {
  final StorageService _storageService;
  bool _isLoading = false;
  List<File> _downloadedFiles = [];

  GalleryProvider({StorageService? storageService})
    : _storageService = storageService ?? StorageService();

  bool get isLoading => _isLoading;
  List<File> get downloadedFiles => _downloadedFiles;

  Future<void> loadDownloadedFiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final downloadsDir = _storageService.appDownloadsDirectory;
      if (await downloadsDir.exists()) {
        final files = downloadsDir.listSync().whereType<File>().where((file) {
          final extension = file.path.toLowerCase().split('.').last;
          return ['jpg', 'jpeg', 'png', 'mp4'].contains(extension);
        }).toList();

        // Sort by modification date (newest first)
        files.sort(
          (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
        );

        _downloadedFiles = files;
      } else {
        _downloadedFiles = [];
      }
    } catch (e) {
      AppLogger.error('Error loading downloaded files: $e');
      _downloadedFiles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _downloadedFiles.remove(file);
        notifyListeners();
        AppLogger.info('File deleted: ${file.path}');
      }
    } catch (e) {
      AppLogger.error('Error deleting file: $e');
      rethrow;
    }
  }

  Future<void> shareFile(File file) async {
    try {
      if (await file.exists()) {
        // For now, we'll use a simple share approach
        // In a real app, you'd use share_plus package
        AppLogger.info('File shared: ${file.path}');
        // TODO: Implement proper file sharing when share_plus is added
      }
    } catch (e) {
      AppLogger.error('Error sharing file: $e');
      rethrow;
    }
  }

  String getFileDate(File file) {
    try {
      final modified = file.lastModifiedSync();
      final now = DateTime.now();
      final difference = now.difference(modified);

      if (difference.inDays > 0) {
        return '${difference.inDays} hari yang lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam yang lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return 'Tanggal tidak diketahui';
    }
  }

  Future<void> refreshGallery() async {
    await loadDownloadedFiles();
  }
}
