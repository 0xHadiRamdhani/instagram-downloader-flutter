import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/instagram_post.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../providers/preview_provider.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  void _initializeScreen() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is InstagramPost) {
      context.read<PreviewProvider>().setCurrentPost(args);
    } else {
      // Try to get from home provider as fallback
      final homeProvider = context.read<HomeProvider>();
      if (homeProvider.currentPost != null) {
        context.read<PreviewProvider>().setCurrentPost(
          homeProvider.currentPost!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareContent(),
          ),
        ],
      ),
      body: Consumer<PreviewProvider>(
        builder: (context, provider, child) {
          if (provider.currentPost == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Media Preview Section
              _buildMediaPreview(provider),

              // Post Info Section
              _buildPostInfo(provider),

              // Download Options Section
              _buildDownloadOptions(provider),

              // Download Button
              _buildDownloadButton(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMediaPreview(PreviewProvider provider) {
    final currentMedia = provider.currentMediaItem;
    if (currentMedia == null) return const SizedBox();

    return Expanded(
      flex: 2,
      child: Container(
        color: AppColors.black.withOpacity(0.05),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Media Display
            _buildMediaDisplay(currentMedia),

            // Media Navigation
            if (provider.hasMultipleMedia) _buildMediaNavigation(provider),

            // Download Progress Overlay
            if (provider.isDownloadInProgress) _buildDownloadProgress(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaDisplay(MediaItem media) {
    // For now, we'll show a placeholder
    // TODO: Implement actual media display with cached_network_image or video_player
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        gradient: LinearGradient(
          colors: AppColors.instagramGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              media.type == MediaType.image ? Icons.image : Icons.videocam,
              size: 80,
              color: AppColors.white,
            ),
            const SizedBox(height: 16),
            Text(
              media.type.displayName,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (media.width != null && media.height != null) ...[
              const SizedBox(height: 8),
              Text(
                '${media.width} × ${media.height}',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMediaNavigation(PreviewProvider provider) {
    return Positioned(
      bottom: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          provider.currentPost!.mediaItems.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => provider.setSelectedMediaIndex(index),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == provider.selectedMediaIndex
                      ? AppColors.white
                      : AppColors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadProgress(PreviewProvider provider) {
    return Container(
      color: AppColors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: provider.downloadProgress,
                strokeWidth: 4,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${(provider.downloadProgress * 100).toInt()}%',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Downloading...',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInfo(PreviewProvider provider) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.inputBackground,
                  child: const Icon(Icons.person, color: AppColors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.formattedUsername,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        provider.formattedDate,
                        style: TextStyle(
                          color: AppColors.grey.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.currentPost!.isVerified == true)
                  const Icon(
                    Icons.verified,
                    color: AppColors.primary,
                    size: 16,
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats
            Text(
              provider.formattedStats,
              style: TextStyle(
                color: AppColors.grey.withOpacity(0.7),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            // Caption
            Text(
              provider.formattedCaption,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadOptions(PreviewProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Download Options',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Quality Selection
          Row(
            children: [
              const Icon(Icons.hd, color: AppColors.grey, size: 20),
              const SizedBox(width: 8),
              const Text('Quality:'),
              const SizedBox(width: 12),
              Expanded(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'low',
                      label: Text('Low'),
                      icon: Icon(Icons.sd),
                    ),
                    ButtonSegment<String>(
                      value: 'medium',
                      label: Text('Medium'),
                      icon: Icon(Icons.hd),
                    ),
                    ButtonSegment<String>(
                      value: 'high',
                      label: Text('High'),
                      icon: Icon(Icons.hdr_strong),
                    ),
                  ],
                  selected: {provider.selectedQuality},
                  onSelectionChanged: (Set<String> newSelection) {
                    provider.setSelectedQuality(newSelection.first);
                  },
                ),
              ),
            ],
          ),

          if (provider.error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDownloadButton(PreviewProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: provider.isDownloadInProgress
              ? null
              : () => _handleDownload(provider),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: provider.isDownloadInProgress
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
                    Text('Downloading...'),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.download, size: 20),
                    const SizedBox(width: 8),
                    Text('Download ${provider.postTypeDisplay}'),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _handleDownload(PreviewProvider provider) async {
    await provider.downloadContent();

    if (provider.currentPost != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${provider.postTypeDisplay} downloaded successfully!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back after successful download
      Navigator.pop(context);
    }
  }

  void _shareContent() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
