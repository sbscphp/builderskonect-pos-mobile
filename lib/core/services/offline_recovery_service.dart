import 'package:builders_konnect/core/core.dart';
import 'package:hive/hive.dart';

/// Service for handling offline data recovery and edge cases
class OfflineRecoveryService {
  static const String _recoveryBoxName = 'offline_recovery';
  static Box<dynamic>? _recoveryBox;

  /// Initialize the recovery service
  static Future<void> initialize() async {
    try {
      _recoveryBox = await Hive.openBox<dynamic>(_recoveryBoxName);
      printty("===> Offline recovery service initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'OfflineRecoveryService initialize');
      rethrow;
    }
  }

  /// Handle app startup recovery
  static Future<void> performStartupRecovery() async {
    try {
      await _recoverInterruptedSyncs();
      await _validateDataIntegrity();
      await _cleanupCorruptedData();
      await _recoverOrphanedOrders();

      printty("Startup recovery completed successfully",
          logName: 'OfflineRecoveryService');
    } catch (e) {
      printty('Startup recovery failed: $e', logName: 'OfflineRecoveryService');
    }
  }

  /// Recover orders that were syncing when app was terminated
  static Future<void> _recoverInterruptedSyncs() async {
    try {
      final syncingOrders =
          await OfflineSalesDatabaseService.getOfflineSalesOrdersByStatus(
              SyncStatus.syncing);

      if (syncingOrders.isNotEmpty) {
        printty(
            'Found ${syncingOrders.length} orders in syncing state, resetting to pending',
            logName: 'OfflineRecoveryService');

        for (final order in syncingOrders) {
          await OfflineSalesDatabaseService.updateSyncStatus(
            localId: order.localId,
            status: SyncStatus.pending,
          );
        }
      }
    } catch (e) {
      printty('Error recovering interrupted syncs: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Validate data integrity and fix corrupted entries
  static Future<void> _validateDataIntegrity() async {
    try {
      final allOrders =
          await OfflineSalesDatabaseService.getAllOfflineSalesOrders();
      final corruptedOrders = <String>[];

      for (final order in allOrders) {
        if (!_isOrderValid(order)) {
          corruptedOrders.add(order.localId);
          printty('Found corrupted order: ${order.localId}',
              logName: 'OfflineRecoveryService');
        }
      }

      // Remove corrupted orders
      for (final localId in corruptedOrders) {
        await OfflineSalesDatabaseService.deleteOfflineSalesOrder(localId);
        await _logRecoveryAction(
            'deleted_corrupted_order', {'local_id': localId});
      }

      if (corruptedOrders.isNotEmpty) {
        printty('Removed ${corruptedOrders.length} corrupted orders',
            logName: 'OfflineRecoveryService');
      }
    } catch (e) {
      printty('Error validating data integrity: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Validate if an order is properly structured
  static bool _isOrderValid(OfflineSalesOrder order) {
    try {
      // Check required fields
      if (order.localId.isEmpty) {
        return false;
      }
      if (order.order.lineItems == null || order.order.lineItems!.isEmpty) {
        return false;
      }
      if (order.createdAt
          .isAfter(DateTime.now().add(const Duration(days: 1)))) {
        return false;
      }

      // Check for valid customer data
      if (order.order.customer == null) {
        return false;
      }

      // Check retry count is reasonable
      if (order.retryCount < 0 || order.retryCount > 10) {
        return false;
      }

      // Check sync status consistency
      if (order.syncStatus == SyncStatus.synced && order.serverId == null) {
        return false;
      }
      if (order.syncStatus == SyncStatus.failed && order.syncError == null) {
        return false;
      }

      return true;
    } catch (e) {
      printty('Error validating order ${order.localId}: $e',
          logName: 'OfflineRecoveryService');
      return false;
    }
  }

  /// Clean up corrupted data that couldn't be recovered
  static Future<void> _cleanupCorruptedData() async {
    try {
      // Get all orders and identify corrupted ones
      final allOrders =
          await OfflineSalesDatabaseService.getAllOfflineSalesOrders();
      final corruptedOrderIds = <String>[];

      // Check each order for corruption
      for (final order in allOrders) {
        if (!_isOrderValid(order)) {
          corruptedOrderIds.add(order.localId);
          printty('Found corrupted order: ${order.localId}',
              logName: 'OfflineRecoveryService');
        }
      }

      // Delete corrupted orders
      for (final localId in corruptedOrderIds) {
        await OfflineSalesDatabaseService.deleteOfflineSalesOrder(localId);
        await _logRecoveryAction(
            'deleted_corrupted_data', {'local_id': localId});
      }

      if (corruptedOrderIds.isNotEmpty) {
        printty('Cleaned up ${corruptedOrderIds.length} corrupted data entries',
            logName: 'OfflineRecoveryService');
      }
    } catch (e) {
      printty('Error cleaning up corrupted data: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Recover orphaned orders (orders without proper references)
  static Future<void> _recoverOrphanedOrders() async {
    try {
      final allOrders =
          await OfflineSalesDatabaseService.getAllOfflineSalesOrders();
      int recoveredCount = 0;

      for (final order in allOrders) {
        bool needsRecovery = false;

        // Check for missing timestamps
        if (order.syncStatus == SyncStatus.failed &&
            order.lastSyncAttempt == null) {
          await OfflineSalesDatabaseService.updateSyncStatus(
            localId: order.localId,
            status: SyncStatus.pending,
          );
          needsRecovery = true;
        }

        // Check for inconsistent sync status
        if (order.syncStatus == SyncStatus.synced && order.syncedAt == null) {
          await OfflineSalesDatabaseService.updateSyncStatus(
            localId: order.localId,
            status: SyncStatus.pending,
          );
          needsRecovery = true;
        }

        if (needsRecovery) {
          recoveredCount++;
          await _logRecoveryAction(
              'recovered_orphaned_order', {'local_id': order.localId});
        }
      }

      if (recoveredCount > 0) {
        printty('Recovered $recoveredCount orphaned orders',
            logName: 'OfflineRecoveryService');
      }
    } catch (e) {
      printty('Error recovering orphaned orders: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Handle network interruption during sync
  static Future<void> handleNetworkInterruption() async {
    try {
      // Reset any orders that were in syncing state back to pending
      await _recoverInterruptedSyncs();

      // Log the interruption
      await _logRecoveryAction('network_interruption', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      printty('Handled network interruption recovery',
          logName: 'OfflineRecoveryService');
    } catch (e) {
      printty('Error handling network interruption: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Handle partial sync failures
  static Future<void> handlePartialSyncFailure(
      List<String> failedOrderIds) async {
    try {
      for (final localId in failedOrderIds) {
        final order =
            await OfflineSalesDatabaseService.getOfflineSalesOrder(localId);
        if (order != null && order.retryCount >= 5) {
          // Mark as permanently failed after 5 retries
          await OfflineSalesDatabaseService.updateSyncStatus(
            localId: localId,
            status: SyncStatus.failed,
            error: 'Maximum retry attempts exceeded',
          );

          await _logRecoveryAction(
              'marked_permanently_failed', {'local_id': localId});
        }
      }

      printty(
          'Handled partial sync failure for ${failedOrderIds.length} orders',
          logName: 'OfflineRecoveryService');
    } catch (e) {
      printty('Error handling partial sync failure: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Validate order data before sync
  static Future<bool> validateOrderForSync(OfflineSalesOrder order) async {
    try {
      // Basic validation
      if (!_isOrderValid(order)) {
        await _logRecoveryAction('validation_failed',
            {'local_id': order.localId, 'reason': 'basic_validation_failed'});
        return false;
      }

      // Check if order is too old (older than 30 days)
      final daysSinceCreation =
          DateTime.now().difference(order.createdAt).inDays;
      if (daysSinceCreation > 30) {
        await _logRecoveryAction('validation_failed', {
          'local_id': order.localId,
          'reason': 'order_too_old',
          'days_old': daysSinceCreation
        });
        return false;
      }

      // Check if retry count is reasonable
      if (order.retryCount >= 10) {
        await _logRecoveryAction('validation_failed', {
          'local_id': order.localId,
          'reason': 'too_many_retries',
          'retry_count': order.retryCount
        });
        return false;
      }

      return true;
    } catch (e) {
      printty('Error validating order for sync: $e',
          logName: 'OfflineRecoveryService');
      return false;
    }
  }

  /// Log recovery actions for debugging
  static Future<void> _logRecoveryAction(
      String action, Map<String, dynamic> details) async {
    try {
      final box = _recoveryBox;
      if (box == null) return;

      final logEntry = {
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
        'details': details,
      };

      final logKey = '${action}_${DateTime.now().millisecondsSinceEpoch}';
      await box.put(logKey, json.encode(logEntry));

      // Keep only last 100 log entries
      if (box.length > 100) {
        final oldestKey = box.keys.first;
        await box.delete(oldestKey);
      }
    } catch (e) {
      printty('Error logging recovery action: $e',
          logName: 'OfflineRecoveryService');
    }
  }

  /// Get recovery logs for debugging
  static Future<List<Map<String, dynamic>>> getRecoveryLogs() async {
    try {
      final box = _recoveryBox;
      if (box == null) return [];

      final logs = <Map<String, dynamic>>[];
      for (final value in box.values) {
        try {
          final logEntry = json.decode(value.toString());
          logs.add(logEntry);
        } catch (e) {
          printty('Error parsing recovery log: $e',
              logName: 'OfflineRecoveryService');
        }
      }

      // Sort by timestamp (newest first)
      logs.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      return logs;
    } catch (e) {
      printty('Error getting recovery logs: $e',
          logName: 'OfflineRecoveryService');
      return [];
    }
  }

  /// Clear old recovery logs
  static Future<void> clearOldLogs({int daysToKeep = 7}) async {
    try {
      final box = _recoveryBox;
      if (box == null) return;

      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      final keysToDelete = <dynamic>[];

      for (final key in box.keys) {
        try {
          final value = box.get(key);
          final logEntry = json.decode(value.toString());
          final timestamp = DateTime.parse(logEntry['timestamp']);

          if (timestamp.isBefore(cutoffDate)) {
            keysToDelete.add(key);
          }
        } catch (e) {
          // If we can't parse it, delete it
          keysToDelete.add(key);
        }
      }

      for (final key in keysToDelete) {
        await box.delete(key);
      }

      if (keysToDelete.isNotEmpty) {
        printty('Cleared ${keysToDelete.length} old recovery logs',
            logName: 'OfflineRecoveryService');
      }
    } catch (e) {
      printty('Error clearing old logs: $e', logName: 'OfflineRecoveryService');
    }
  }
}
