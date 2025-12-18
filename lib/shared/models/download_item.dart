import 'package:equatable/equatable.dart';
import 'instagram_post.dart';

/// Media type for downloads
enum MediaType { image, video, reel, carousel, story }

/// Extension for MediaType display name
extension MediaTypeExtension on MediaType {
  String get displayName {
    switch (this) {
      case MediaType.image:
        return 'Image';
      case MediaType.video:
        return 'Video';
      case MediaType.reel:
        return 'Reel';
      case MediaType.carousel:
        return 'Carousel';
      case MediaType.story:
        return 'Story';
    }
  }
}

/// Download item model
class DownloadItem extends Equatable {
  final String id;
  final InstagramPost post;
  final MediaType type;
  final String mediaUrl;
  final String? quality;
  final String status;
  final String? filePath;
  final String? error;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  const DownloadItem({
    required this.id,
    required this.post,
    required this.type,
    required this.mediaUrl,
    this.quality,
    this.status = 'pending',
    this.filePath,
    this.error,
    required this.createdAt,
    this.completedAt,
    this.updatedAt,
  });

  /// Copy with method
  DownloadItem copyWith({
    String? id,
    InstagramPost? post,
    MediaType? type,
    String? mediaUrl,
    String? quality,
    String? status,
    String? filePath,
    String? error,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      post: post ?? this.post,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      quality: quality ?? this.quality,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post': post.toJson(),
      'type': type.name,
      'mediaUrl': mediaUrl,
      'quality': quality,
      'status': status,
      'filePath': filePath,
      'error': error,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      id: json['id'],
      post: InstagramPost.fromJson(json['post']),
      type: MediaType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaType.image,
      ),
      mediaUrl: json['mediaUrl'],
      quality: json['quality'],
      status: json['status'] ?? 'pending',
      filePath: json['filePath'],
      error: json['error'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// Convert to string
  @override
  String toString() {
    return 'DownloadItem(id: $id, post: ${post.id}, type: $type, status: $status)';
  }

  @override
  List<Object?> get props => [
    id,
    post,
    type,
    mediaUrl,
    quality,
    status,
    filePath,
    error,
    createdAt,
    completedAt,
    updatedAt,
  ];
}

/// Download status constants
class DownloadStatus {
  static const String pending = 'pending';
  static const String downloading = 'downloading';
  static const String paused = 'paused';
  static const String completed = 'completed';
  static const String failed = 'failed';
  static const String cancelled = 'cancelled';
  static const String queued = 'queued';
}
