import 'package:builders_konnect/core/models/models.dart';

/// Enum for sync status of offline sales orders
enum SyncStatus {
  pending,
  syncing,
  synced,
  failed,
}

/// Offline sales order model that extends the existing Order model
/// with offline-specific fields for sync management
class OfflineSalesOrder {
  final String localId;
  final String? serverId;
  final Order order;
  final SyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime? lastSyncAttempt;
  final int retryCount;
  final String? syncError;
  final bool createdOffline;
  final DateTime? syncedAt;
  final Map<String, dynamic>? metadata;

  OfflineSalesOrder({
    required this.localId,
    this.serverId,
    required this.order,
    this.syncStatus = SyncStatus.pending,
    required this.createdAt,
    this.lastSyncAttempt,
    this.retryCount = 0,
    this.syncError,
    this.createdOffline = true,
    this.syncedAt,
    this.metadata,
  });

  /// Create a copy of this order with updated fields
  OfflineSalesOrder copyWith({
    String? localId,
    String? serverId,
    Order? order,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? lastSyncAttempt,
    int? retryCount,
    String? syncError,
    bool? createdOffline,
    DateTime? syncedAt,
    Map<String, dynamic>? metadata,
  }) {
    return OfflineSalesOrder(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      order: order ?? this.order,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      retryCount: retryCount ?? this.retryCount,
      syncError: syncError ?? this.syncError,
      createdOffline: createdOffline ?? this.createdOffline,
      syncedAt: syncedAt ?? this.syncedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() => {
        'local_id': localId,
        'server_id': serverId,
        'order': order.toJson(),
        'sync_status': syncStatus.name,
        'created_at': createdAt.toIso8601String(),
        'last_sync_attempt': lastSyncAttempt?.toIso8601String(),
        'retry_count': retryCount,
        'sync_error': syncError,
        'created_offline': createdOffline,
        'synced_at': syncedAt?.toIso8601String(),
        'metadata': metadata,
      };

  /// Create from JSON
  factory OfflineSalesOrder.fromJson(Map<String, dynamic> json) {
    return OfflineSalesOrder(
      localId: json['local_id'],
      serverId: json['server_id'],
      order: Order.fromJson(json['order']),
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at']),
      lastSyncAttempt: json['last_sync_attempt'] != null
          ? DateTime.parse(json['last_sync_attempt'])
          : null,
      retryCount: json['retry_count'] ?? 0,
      syncError: json['sync_error'],
      createdOffline: json['created_offline'] ?? true,
      syncedAt:
          json['synced_at'] != null ? DateTime.parse(json['synced_at']) : null,
      metadata: json['metadata'],
    );
  }

  /// Check if this order needs to be synced
  bool get needsSync =>
      syncStatus == SyncStatus.pending || syncStatus == SyncStatus.failed;

  /// Check if this order is currently being synced
  bool get isSyncing => syncStatus == SyncStatus.syncing;

  /// Check if this order has been successfully synced
  bool get isSynced => syncStatus == SyncStatus.synced;

  /// Check if sync has failed
  bool get hasSyncFailed => syncStatus == SyncStatus.failed;

  /// Get display status for UI
  String get displayStatus {
    switch (syncStatus) {
      case SyncStatus.pending:
        return 'Pending Sync';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.failed:
        return 'Sync Failed';
    }
  }

  /// Check if order can be retried
  bool get canRetry => syncStatus == SyncStatus.failed && retryCount < 5;

  @override
  String toString() {
    return 'OfflineSalesOrder(localId: $localId, serverId: $serverId, syncStatus: $syncStatus, createdAt: $createdAt)';
  }
}

/// Sync result model for tracking sync operations
class SyncResult {
  final bool success;
  final String? error;
  final String? serverId;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    this.error,
    this.serverId,
    required this.timestamp,
  });

  factory SyncResult.success({String? serverId}) {
    return SyncResult(
      success: true,
      serverId: serverId,
      timestamp: DateTime.now(),
    );
  }

  factory SyncResult.failure(String error) {
    return SyncResult(
      success: false,
      error: error,
      timestamp: DateTime.now(),
    );
  }
}

/// Batch sync result for multiple orders
class BatchSyncResult {
  final List<SyncResult> results;
  final int totalOrders;
  final int successCount;
  final int failureCount;

  BatchSyncResult({
    required this.results,
    required this.totalOrders,
    required this.successCount,
    required this.failureCount,
  });

  bool get allSuccessful => failureCount == 0;
  bool get hasFailures => failureCount > 0;
  double get successRate => totalOrders > 0 ? successCount / totalOrders : 0.0;
}
