import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class RecentDownloadsWidget extends StatelessWidget {
  const RecentDownloadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement actual recent downloads data
    final recentDownloads = _getMockRecentDownloads();

    if (recentDownloads.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentDownloads.length,
        itemBuilder: (context, index) {
          final download = recentDownloads[index];
          return _buildDownloadItem(context, download);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.inputBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.grey.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done,
            size: 32,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No recent downloads',
            style: TextStyle(
              color: AppColors.grey.withOpacity(0.7),
              fontSize: 14,
              fontFamily: 'InstagramSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadItem(
    BuildContext context,
    Map<String, dynamic> download,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              gradient: LinearGradient(
                colors: AppColors.instagramGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                download['type'] == 'image' ? Icons.image : Icons.videocam,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            download['username'],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'InstagramSans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            download['time'],
            style: TextStyle(
              fontSize: 10,
              color: AppColors.grey.withOpacity(0.7),
              fontFamily: 'InstagramSans',
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockRecentDownloads() {
    // TODO: Replace with actual recent downloads from storage/database
    return [
      {
        'id': '1',
        'username': '@travel_lover',
        'type': 'image',
        'time': '2h ago',
      },
      {
        'id': '2',
        'username': '@foodie_paradise',
        'type': 'video',
        'time': '5h ago',
      },
      {
        'id': '3',
        'username': '@nature_photography',
        'type': 'image',
        'time': '1d ago',
      },
    ];
  }
}
