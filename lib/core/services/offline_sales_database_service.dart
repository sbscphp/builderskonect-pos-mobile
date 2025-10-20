import 'package:builders_konnect/core/core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Service for managing offline sales orders in local database
class OfflineSalesDatabaseService {
  static const String _boxName = 'offline_sales_orders';
  static const String _metadataBoxName = 'offline_sales_metadata';
  static Box<dynamic>? _salesBox;
  static Box<dynamic>? _metadataBox;
  static const Uuid _uuid = Uuid();

  /// Initialize the offline sales database
  static Future<void> initialize() async {
    try {
      _salesBox = await Hive.openBox<dynamic>(_boxName);
      _metadataBox = await Hive.openBox<dynamic>(_metadataBoxName);
      printty("===> Offline sales database initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'OfflineSalesDatabaseService initialize');
      rethrow;
    }
  }

  /// Get the sales box, initializing if necessary
  static Future<Box<dynamic>> get _getSalesBox async {
    if (_salesBox == null || !_salesBox!.isOpen) {
      await initialize();
    }
    return _salesBox!;
  }

  /// Get the metadata box, initializing if necessary
  static Future<Box<dynamic>> get _getMetadataBox async {
    if (_metadataBox == null || !_metadataBox!.isOpen) {
      await initialize();
    }
    return _metadataBox!;
  }

  /// Create a new offline sales order
  static Future<OfflineSalesOrder> createOfflineSalesOrder({
    required Order order,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final box = await _getSalesBox;
      final localId = _uuid.v4();

      final offlineOrder = OfflineSalesOrder(
        localId: localId,
        order: order,
        syncStatus: SyncStatus.pending,
        createdAt: DateTime.now(),
        createdOffline: true,
        metadata: metadata,
      );

      // Store as JSON string to avoid Hive type adapter issues
      await box.put(localId, json.encode(offlineOrder.toJson()));

      printty("Created offline sales order: $localId");
      return offlineOrder;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService createOfflineSalesOrder');
      rethrow;
    }
  }

  /// Get an offline sales order by local ID
  static Future<OfflineSalesOrder?> getOfflineSalesOrder(String localId) async {
    try {
      final box = await _getSalesBox;
      final jsonString = box.get(localId);

      if (jsonString == null) return null;

      final json = jsonDecode(jsonString);
      return OfflineSalesOrder.fromJson(json);
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService getOfflineSalesOrder');
      return null;
    }
  }

  /// Get all offline sales orders
  static Future<List<OfflineSalesOrder>> getAllOfflineSalesOrders() async {
    try {
      final box = await _getSalesBox;
      final orders = <OfflineSalesOrder>[];

      for (final key in box.keys) {
        final jsonString = box.get(key);
        if (jsonString != null) {
          try {
            final json = jsonDecode(jsonString);
            orders.add(OfflineSalesOrder.fromJson(json));
          } catch (e) {
            printty('Error parsing order $key: $e',
                logName: 'OfflineSalesDatabaseService');
          }
        }
      }

      // Sort by creation date, newest first
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService getAllOfflineSalesOrders');
      return [];
    }
  }

  /// Get offline sales orders by sync status
  static Future<List<OfflineSalesOrder>> getOfflineSalesOrdersByStatus(
      SyncStatus status) async {
    try {
      final allOrders = await getAllOfflineSalesOrders();
      return allOrders.where((order) => order.syncStatus == status).toList();
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService getOfflineSalesOrdersByStatus');
      return [];
    }
  }

  /// Get pending sync orders
  static Future<List<OfflineSalesOrder>> getPendingSyncOrders() async {
    return getOfflineSalesOrdersByStatus(SyncStatus.pending);
  }

  /// Get failed sync orders
  static Future<List<OfflineSalesOrder>> getFailedSyncOrders() async {
    return getOfflineSalesOrdersByStatus(SyncStatus.failed);
  }

  /// Update an offline sales order
  static Future<bool> updateOfflineSalesOrder(OfflineSalesOrder order) async {
    try {
      final box = await _getSalesBox;
      await box.put(order.localId, json.encode(order.toJson()));
      printty("Updated offline sales order: ${order.localId}");
      return true;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService updateOfflineSalesOrder');
      return false;
    }
  }

  /// Update sync status of an offline sales order
  static Future<bool> updateSyncStatus({
    required String localId,
    required SyncStatus status,
    String? serverId,
    String? error,
    DateTime? syncedAt,
  }) async {
    try {
      final order = await getOfflineSalesOrder(localId);
      if (order == null) return false;

      final updatedOrder = order.copyWith(
        syncStatus: status,
        serverId: serverId ?? order.serverId,
        syncError: error,
        lastSyncAttempt: DateTime.now(),
        retryCount: status == SyncStatus.failed
            ? order.retryCount + 1
            : order.retryCount,
        syncedAt: syncedAt,
      );

      return await updateOfflineSalesOrder(updatedOrder);
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService updateSyncStatus');
      return false;
    }
  }

  /// Delete an offline sales order
  static Future<bool> deleteOfflineSalesOrder(String localId) async {
    try {
      final box = await _getSalesBox;
      await box.delete(localId);
      printty("Deleted offline sales order: $localId");
      return true;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService deleteOfflineSalesOrder');
      return false;
    }
  }

  /// Clear all offline sales orders
  static Future<bool> clearAllOfflineSalesOrders() async {
    try {
      final box = await _getSalesBox;
      await box.clear();
      printty("Cleared all offline sales orders");
      return true;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService clearAllOfflineSalesOrders');
      return false;
    }
  }

  /// Get count of orders by status
  static Future<Map<SyncStatus, int>> getOrderCountsByStatus() async {
    try {
      final allOrders = await getAllOfflineSalesOrders();
      final counts = <SyncStatus, int>{
        SyncStatus.pending: 0,
        SyncStatus.syncing: 0,
        SyncStatus.synced: 0,
        SyncStatus.failed: 0,
      };

      for (final order in allOrders) {
        counts[order.syncStatus] = (counts[order.syncStatus] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService getOrderCountsByStatus');
      return {};
    }
  }

  /// Store sync metadata
  static Future<void> storeSyncMetadata(String key, dynamic value) async {
    try {
      final box = await _getMetadataBox;
      await box.put(key, value);
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService storeSyncMetadata');
    }
  }

  /// Get sync metadata
  static Future<T?> getSyncMetadata<T>(String key) async {
    try {
      final box = await _getMetadataBox;
      return box.get(key) as T?;
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService getSyncMetadata');
      return null;
    }
  }

  /// Get last sync timestamp
  static Future<DateTime?> getLastSyncTimestamp() async {
    final timestamp = await getSyncMetadata<String>('last_sync_timestamp');
    return timestamp != null ? DateTime.tryParse(timestamp) : null;
  }

  /// Update last sync timestamp
  static Future<void> updateLastSyncTimestamp() async {
    await storeSyncMetadata(
        'last_sync_timestamp', DateTime.now().toIso8601String());
  }

  /// Check if database needs cleanup (remove old synced orders)
  static Future<void> cleanupOldSyncedOrders({int maxAge = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: maxAge));
      final allOrders = await getAllOfflineSalesOrders();

      for (final order in allOrders) {
        if (order.syncStatus == SyncStatus.synced &&
            order.syncedAt != null &&
            order.syncedAt!.isBefore(cutoffDate)) {
          await deleteOfflineSalesOrder(order.localId);
        }
      }

      printty("Cleaned up old synced orders older than $maxAge days");
    } catch (e) {
      printty(e.toString(),
          logName: 'OfflineSalesDatabaseService cleanupOldSyncedOrders');
    }
  }

  /// Close the database boxes
  static Future<void> close() async {
    try {
      await _salesBox?.close();
      await _metadataBox?.close();
      _salesBox = null;
      _metadataBox = null;
      printty("Closed offline sales database");
    } catch (e) {
      printty(e.toString(), logName: 'OfflineSalesDatabaseService close');
    }
  }
}
