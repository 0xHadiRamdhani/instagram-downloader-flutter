enum PostType { post, reel, tv, story, carousel }

enum MediaType { image, video, carousel }

class InstagramPost {
  final String id;
  final String url;
  final String username;
  final String? displayName;
  final String? caption;
  final String? profilePictureUrl;
  final List<MediaItem> mediaItems;
  final DateTime createdAt;
  final PostType type;
  final int? likeCount;
  final int? commentCount;
  final bool? isVerified;
  final Map<String, dynamic>? metadata;

  const InstagramPost({
    required this.id,
    required this.url,
    required this.username,
    this.displayName,
    this.caption,
    this.profilePictureUrl,
    required this.mediaItems,
    required this.createdAt,
    required this.type,
    this.likeCount,
    this.commentCount,
    this.isVerified,
    this.metadata,
  });

  InstagramPost copyWith({
    String? id,
    String? url,
    String? username,
    String? displayName,
    String? caption,
    String? profilePictureUrl,
    List<MediaItem>? mediaItems,
    DateTime? createdAt,
    PostType? type,
    int? likeCount,
    int? commentCount,
    bool? isVerified,
    Map<String, dynamic>? metadata,
  }) {
    return InstagramPost(
      id: id ?? this.id,
      url: url ?? this.url,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      caption: caption ?? this.caption,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      mediaItems: mediaItems ?? this.mediaItems,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isVerified: isVerified ?? this.isVerified,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'username': username,
      'displayName': displayName,
      'caption': caption,
      'profilePictureUrl': profilePictureUrl,
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'type': type.name,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isVerified': isVerified,
      'metadata': metadata,
    };
  }

  factory InstagramPost.fromJson(Map<String, dynamic> json) {
    return InstagramPost(
      id: json['id'],
      url: json['url'],
      username: json['username'],
      displayName: json['displayName'],
      caption: json['caption'],
      profilePictureUrl: json['profilePictureUrl'],
      mediaItems: (json['mediaItems'] as List)
          .map((item) => MediaItem.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      type: PostType.values.firstWhere((e) => e.name == json['type']),
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      isVerified: json['isVerified'],
      metadata: json['metadata'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstagramPost &&
        other.id == id &&
        other.url == url &&
        other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ username.hashCode;
}

class MediaItem {
  final String id;
  final String url;
  final MediaType type;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final String? quality;
  final int? size;
  final String? fileName;
  final Map<String, dynamic>? metadata;

  const MediaItem({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.quality,
    this.size,
    this.fileName,
    this.metadata,
  });

  MediaItem copyWith({
    String? id,
    String? url,
    MediaType? type,
    String? thumbnailUrl,
    int? width,
    int? height,
    String? quality,
    int? size,
    String? fileName,
    Map<String, dynamic>? metadata,
  }) {
    return MediaItem(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      size: size ?? this.size,
      fileName: fileName ?? this.fileName,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type.name,
      'thumbnailUrl': thumbnailUrl,
      'width': width,
      'height': height,
      'quality': quality,
      'size': size,
      'fileName': fileName,
      'metadata': metadata,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'],
      url: json['url'],
      type: MediaType.values.firstWhere((e) => e.name == json['type']),
      thumbnailUrl: json['thumbnailUrl'],
      width: json['width'],
      height: json['height'],
      quality: json['quality'],
      size: json['size'],
      fileName: json['fileName'],
      metadata: json['metadata'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaItem &&
        other.id == id &&
        other.url == url &&
        other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ type.hashCode;
}

extension PostTypeExtension on PostType {
  String get displayName {
    switch (this) {
      case PostType.post:
        return 'Post';
      case PostType.reel:
        return 'Reel';
      case PostType.tv:
        return 'IGTV';
      case PostType.story:
        return 'Story';
      case PostType.carousel:
        return 'Carousel';
    }
  }

  String get icon {
    switch (this) {
      case PostType.post:
        return '📷';
      case PostType.reel:
        return '🎬';
      case PostType.tv:
        return '📺';
      case PostType.story:
        return '💫';
      case PostType.carousel:
        return '🖼️';
    }
  }
}

extension MediaTypeExtension on MediaType {
  String get displayName {
    switch (this) {
      case MediaType.image:
        return 'Image';
      case MediaType.video:
        return 'Video';
      case MediaType.carousel:
        return 'Carousel';
    }
  }

  String get fileExtension {
    switch (this) {
      case MediaType.image:
        return '.jpg';
      case MediaType.video:
        return '.mp4';
      case MediaType.carousel:
        return '.jpg';
    }
  }
}
