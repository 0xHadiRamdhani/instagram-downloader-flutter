import 'package:flutter/material.dart';
import '../../../../shared/models/instagram_post.dart';

enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

enum DownloadType { image, video, story, carousel }

class DownloadItem {
  final String id;
  final InstagramPost post;
  final DownloadStatus status;
  final double progress;
  final String? localPath;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final int? fileSize;
  final String? fileName;
  final DownloadType type;
  final Map<String, dynamic>? metadata;

  const DownloadItem({
    required this.id,
    required this.post,
    required this.status,
    this.progress = 0.0,
    this.localPath,
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
    this.fileSize,
    this.fileName,
    required this.type,
    this.metadata,
  });

  DownloadItem copyWith({
    String? id,
    InstagramPost? post,
    DownloadStatus? status,
    double? progress,
    String? localPath,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorMessage,
    int? fileSize,
    String? fileName,
    DownloadType? type,
    Map<String, dynamic>? metadata,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      post: post ?? this.post,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      fileSize: fileSize ?? this.fileSize,
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post': post.toJson(),
      'status': status.name,
      'progress': progress,
      'localPath': localPath,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'fileSize': fileSize,
      'fileName': fileName,
      'type': type.name,
      'metadata': metadata,
    };
  }

  factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      id: json['id'],
      post: InstagramPost.fromJson(json['post']),
      status: DownloadStatus.values.firstWhere((e) => e.name == json['status']),
      progress: json['progress']?.toDouble() ?? 0.0,
      localPath: json['localPath'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      errorMessage: json['errorMessage'],
      fileSize: json['fileSize'],
      fileName: json['fileName'],
      type: DownloadType.values.firstWhere((e) => e.name == json['type']),
      metadata: json['metadata'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadItem && other.id == id && other.post.id == post.id;
  }

  @override
  int get hashCode => id.hashCode ^ post.id.hashCode;

  @override
  String toString() {
    return 'DownloadItem(id: $id, status: $status, progress: $progress, type: $type)';
  }
}

extension DownloadStatusExtension on DownloadStatus {
  String get displayName {
    switch (this) {
      case DownloadStatus.pending:
        return 'Pending';
      case DownloadStatus.downloading:
        return 'Downloading';
      case DownloadStatus.paused:
        return 'Paused';
      case DownloadStatus.completed:
        return 'Completed';
      case DownloadStatus.failed:
        return 'Failed';
      case DownloadStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case DownloadStatus.pending:
        return const Color(0xFF007AFF);
      case DownloadStatus.downloading:
        return const Color(0xFF34C759);
      case DownloadStatus.paused:
        return const Color(0xFFFF9500);
      case DownloadStatus.completed:
        return const Color(0xFF34C759);
      case DownloadStatus.failed:
        return const Color(0xFFFF3B30);
      case DownloadStatus.cancelled:
        return const Color(0xFF8E8E93);
    }
  }

  IconData get icon {
    switch (this) {
      case DownloadStatus.pending:
        return Icons.schedule;
      case DownloadStatus.downloading:
        return Icons.download;
      case DownloadStatus.paused:
        return Icons.pause;
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.cancelled:
        return Icons.cancel;
    }
  }
}

extension DownloadTypeExtension on DownloadType {
  String get displayName {
    switch (this) {
      case DownloadType.image:
        return 'Image';
      case DownloadType.video:
        return 'Video';
      case DownloadType.story:
        return 'Story';
      case DownloadType.carousel:
        return 'Carousel';
    }
  }

  String get fileExtension {
    switch (this) {
      case DownloadType.image:
        return '.jpg';
      case DownloadType.video:
        return '.mp4';
      case DownloadType.story:
        return '.jpg';
      case DownloadType.carousel:
        return '.jpg';
    }
  }

  IconData get icon {
    switch (this) {
      case DownloadType.image:
        return Icons.image;
      case DownloadType.video:
        return Icons.videocam;
      case DownloadType.story:
        return Icons.circle;
      case DownloadType.carousel:
        return Icons.view_carousel;
    }
  }
}
