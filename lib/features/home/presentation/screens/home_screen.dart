import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/services/clipboard_service.dart';
import '../providers/home_provider.dart';
import '../widgets/url_input_widget.dart';
import '../widgets/clipboard_detection_widget.dart';
import '../widgets/recent_downloads_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  void _initializeScreen() {
    final provider = context.read<HomeProvider>();

    // Check clipboard on app launch
    provider.checkClipboard();

    // Start clipboard monitoring if enabled
    if (StorageService.getBool(StorageKeys.autoDownloadClipboard) ?? true) {
      provider.startClipboardMonitoring();
    }

    AppLogger.info('Home screen initialized');
  }

  @override
  void dispose() {
    context.read<HomeProvider>().stopClipboardMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Downloader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () {
              Navigator.pushNamed(context, '/gallery');
            },
            tooltip: 'Galeri',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo and Title
                  _buildAppHeader(),

                  const SizedBox(height: 32),

                  // URL Input Section
                  _buildUrlInputSection(provider),

                  const SizedBox(height: 24),

                  // Clipboard Detection
                  if (provider.clipboardUrl != null)
                    _buildClipboardDetection(provider),

                  const SizedBox(height: 24),

                  // Recent Downloads
                  _buildRecentDownloadsSection(),

                  const Spacer(),

                  // Download Button
                  _buildDownloadButton(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.instagramGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.download, size: 40, color: AppColors.white),
        ),
        const SizedBox(height: 16),
        Text(
          'Download Instagram Content',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Paste an Instagram URL to download photos, videos, reels, or stories',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUrlInputSection(HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instagram URL',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        UrlInputWidget(
          initialValue: provider.urlInput,
          onChanged: provider.setUrlInput,
          onSubmitted: (url) => _processUrl(provider, url),
          errorText: provider.error,
          isLoading: provider.isLoading,
        ),
      ],
    );
  }

  Widget _buildClipboardDetection(HomeProvider provider) {
    return ClipboardDetectionWidget(
      url: provider.clipboardUrl!,
      onUseUrl: () {
        provider.useClipboardUrl();
      },
      onDismiss: () {
        provider.setClipboardUrl(null);
      },
    );
  }

  Widget _buildRecentDownloadsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Downloads',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () => _openGallery(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const RecentDownloadsWidget(),
      ],
    );
  }

  Widget _buildDownloadButton(HomeProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isLoading
            ? null
            : () => _processUrl(provider, provider.urlInput),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: provider.isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Processing...'),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Download'),
                ],
              ),
      ),
    );
  }

  Future<void> _processUrl(HomeProvider provider, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an Instagram URL'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await provider.processUrl(url);

    if (provider.currentPost != null && mounted) {
      // Navigate to preview screen
      Navigator.pushNamed(context, '/preview', arguments: provider.currentPost);
    }
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _openGallery() {
    Navigator.pushNamed(context, '/gallery');
  }
}
