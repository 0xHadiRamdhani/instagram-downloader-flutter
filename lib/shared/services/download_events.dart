// Download events for download state management

/// Base class for download events
abstract class DownloadEvent {
  final String downloadId;
  final DateTime timestamp;

  DownloadEvent({required this.downloadId, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

/// Download progress event
class DownloadProgressEvent extends DownloadEvent {
  final double progress;
  final int bytesDownloaded;
  final int totalBytes;

  DownloadProgressEvent({
    required String downloadId,
    required this.progress,
    required this.bytesDownloaded,
    required this.totalBytes,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadProgressEvent(downloadId: $downloadId, progress: ${(progress * 100).toStringAsFixed(1)}%, bytesDownloaded: $bytesDownloaded, totalBytes: $totalBytes)';
  }
}

/// Download complete event
class DownloadCompleteEvent extends DownloadEvent {
  final String filePath;
  final int fileSize;
  final Duration downloadDuration;

  DownloadCompleteEvent({
    required String downloadId,
    required this.filePath,
    required this.fileSize,
    required this.downloadDuration,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadCompleteEvent(downloadId: $downloadId, filePath: $filePath, fileSize: $fileSize, downloadDuration: $downloadDuration)';
  }
}

/// Download failed event
class DownloadFailedEvent extends DownloadEvent {
  final String error;
  final int? retryCount;
  final bool canRetry;

  DownloadFailedEvent({
    required String downloadId,
    required this.error,
    this.retryCount,
    this.canRetry = true,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadFailedEvent(downloadId: $downloadId, error: $error, retryCount: $retryCount, canRetry: $canRetry)';
  }
}

/// Download paused event
class DownloadPausedEvent extends DownloadEvent {
  final double progressWhenPaused;

  DownloadPausedEvent({
    required String downloadId,
    required this.progressWhenPaused,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadPausedEvent(downloadId: $downloadId, progressWhenPaused: ${(progressWhenPaused * 100).toStringAsFixed(1)}%)';
  }
}

/// Download resumed event
class DownloadResumedEvent extends DownloadEvent {
  final double progressWhenResumed;

  DownloadResumedEvent({
    required String downloadId,
    required this.progressWhenResumed,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadResumedEvent(downloadId: $downloadId, progressWhenResumed: ${(progressWhenResumed * 100).toStringAsFixed(1)}%)';
  }
}

/// Download cancelled event
class DownloadCancelledEvent extends DownloadEvent {
  final double progressWhenCancelled;
  final String reason;

  DownloadCancelledEvent({
    required String downloadId,
    required this.progressWhenCancelled,
    required this.reason,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadCancelledEvent(downloadId: $downloadId, progressWhenCancelled: ${(progressWhenCancelled * 100).toStringAsFixed(1)}%, reason: $reason)';
  }
}

/// Download started event
class DownloadStartedEvent extends DownloadEvent {
  final String url;
  final String fileName;
  final int? expectedFileSize;

  DownloadStartedEvent({
    required String downloadId,
    required this.url,
    required this.fileName,
    this.expectedFileSize,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadStartedEvent(downloadId: $downloadId, url: $url, fileName: $fileName, expectedFileSize: $expectedFileSize)';
  }
}

/// Download queued event
class DownloadQueuedEvent extends DownloadEvent {
  final int queuePosition;

  DownloadQueuedEvent({
    required String downloadId,
    required this.queuePosition,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadQueuedEvent(downloadId: $downloadId, queuePosition: $queuePosition)';
  }
}

/// Download retry event
class DownloadRetryEvent extends DownloadEvent {
  final int retryAttempt;
  final String previousError;

  DownloadRetryEvent({
    required String downloadId,
    required this.retryAttempt,
    required this.previousError,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadRetryEvent(downloadId: $downloadId, retryAttempt: $retryAttempt, previousError: $previousError)';
  }
}

/// Download permission event
class DownloadPermissionEvent extends DownloadEvent {
  final String permission;
  final bool granted;

  DownloadPermissionEvent({
    required String downloadId,
    required this.permission,
    required this.granted,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadPermissionEvent(downloadId: $downloadId, permission: $permission, granted: $granted)';
  }
}

/// Download network event
class DownloadNetworkEvent extends DownloadEvent {
  final String networkStatus;
  final bool isConnected;

  DownloadNetworkEvent({
    required String downloadId,
    required this.networkStatus,
    required this.isConnected,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadNetworkEvent(downloadId: $downloadId, networkStatus: $networkStatus, isConnected: $isConnected)';
  }
}

/// Download storage event
class DownloadStorageEvent extends DownloadEvent {
  final String storageStatus;
  final int availableSpace;
  final int requiredSpace;

  DownloadStorageEvent({
    required String downloadId,
    required this.storageStatus,
    required this.availableSpace,
    required this.requiredSpace,
    DateTime? timestamp,
  }) : super(downloadId: downloadId, timestamp: timestamp);

  @override
  String toString() {
    return 'DownloadStorageEvent(downloadId: $downloadId, storageStatus: $storageStatus, availableSpace: $availableSpace, requiredSpace: $requiredSpace)';
  }
}
