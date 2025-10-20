import 'dart:async';
import 'dart:math';

import 'package:builders_konnect/core/core.dart';

/// Service for synchronizing offline sales orders with the server
class SalesSyncService {
  static SalesSyncService? _instance;
  static SalesSyncService get instance => _instance ??= SalesSyncService._();

  SalesSyncService._();

  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _syncTimer;
  bool _isSyncing = false;
  bool _isInitialized = false;

  // Stream controllers for sync events
  final StreamController<SyncEvent> _syncEventController =
      StreamController<SyncEvent>.broadcast();

  /// Stream of sync events
  Stream<SyncEvent> get syncEventStream => _syncEventController.stream;

  /// Current sync status
  bool get isSyncing => _isSyncing;

  /// Initialize the sync service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Listen to connectivity changes
      _connectivitySubscription =
          ConnectivityService.instance.isOnlineStream.listen(
        _onConnectivityChanged,
        onError: (error) {
          printty('Sync service connectivity stream error: $error',
              logName: 'SalesSyncService');
        },
      );

      // Start periodic sync checks
      _startPeriodicSync();

      _isInitialized = true;
      printty("===> Sales sync service initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'SalesSyncService initialize');
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(bool isOnline) async {
    if (isOnline) {
      printty('Connection restored, triggering sync',
          logName: 'SalesSyncService');
      // Wait a bit for connection to stabilize
      await Future.delayed(const Duration(seconds: 2));
      await syncPendingOrders();
    }
  }

  /// Start periodic sync checks
  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5), // Sync every 5 minutes when online
      (_) => _periodicSyncCheck(),
    );
  }

  /// Periodic sync check
  Future<void> _periodicSyncCheck() async {
    if (ConnectivityService.instance.isOnline && !_isSyncing) {
      await syncPendingOrders();
    }
  }

  /// Sync all pending orders
  Future<BatchSyncResult> syncPendingOrders() async {
    if (_isSyncing) {
      printty('Sync already in progress', logName: 'SalesSyncService');
      return BatchSyncResult(
          results: [], totalOrders: 0, successCount: 0, failureCount: 0);
    }

    if (!ConnectivityService.instance.isOnline) {
      printty('Cannot sync: device is offline', logName: 'SalesSyncService');
      return BatchSyncResult(
          results: [], totalOrders: 0, successCount: 0, failureCount: 0);
    }

    _isSyncing = true;
    _emitSyncEvent(SyncEvent.started());

    try {
      final pendingOrders =
          await OfflineSalesDatabaseService.getPendingSyncOrders();
      final failedOrders =
          await OfflineSalesDatabaseService.getFailedSyncOrders();

      // Combine pending and failed orders that can be retried
      final ordersToSync = [
        ...pendingOrders,
        ...failedOrders.where((order) => order.canRetry),
      ];

      if (ordersToSync.isEmpty) {
        printty('No orders to sync', logName: 'SalesSyncService');
        _emitSyncEvent(SyncEvent.completed(0, 0));
        return BatchSyncResult(
            results: [], totalOrders: 0, successCount: 0, failureCount: 0);
      }

      printty('Starting sync for ${ordersToSync.length} orders',
          logName: 'SalesSyncService');

      final results = <SyncResult>[];
      final failedOrderIds = <String>[];
      int successCount = 0;
      int failureCount = 0;

      for (final order in ordersToSync) {
        if (!ConnectivityService.instance.isOnline) {
          printty('Connection lost during sync', logName: 'SalesSyncService');
          break;
        }

        final result = await _syncSingleOrder(order);
        results.add(result);

        if (result.success) {
          successCount++;
        } else {
          failureCount++;
          failedOrderIds.add(order.localId);
        }

        // Emit progress event
        _emitSyncEvent(SyncEvent.progress(
          ordersToSync.length,
          results.length,
          successCount,
          failureCount,
        ));

        // Small delay between syncs to avoid overwhelming the server
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await OfflineSalesDatabaseService.updateLastSyncTimestamp();

      final batchResult = BatchSyncResult(
        results: results,
        totalOrders: ordersToSync.length,
        successCount: successCount,
        failureCount: failureCount,
      );

      _emitSyncEvent(SyncEvent.completed(successCount, failureCount));

      // Handle partial sync failures
      if (failureCount > 0 && failedOrderIds.isNotEmpty) {
        await OfflineRecoveryService.handlePartialSyncFailure(failedOrderIds);
      }

      printty('Sync completed: $successCount success, $failureCount failed',
          logName: 'SalesSyncService');
      return batchResult;
    } catch (e) {
      printty('Sync error: $e', logName: 'SalesSyncService');
      _emitSyncEvent(SyncEvent.error(e.toString()));
      return BatchSyncResult(
          results: [], totalOrders: 0, successCount: 0, failureCount: 1);
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a single order
  Future<SyncResult> _syncSingleOrder(OfflineSalesOrder offlineOrder) async {
    try {
      // Validate order before sync
      final isValid =
          await OfflineRecoveryService.validateOrderForSync(offlineOrder);
      if (!isValid) {
        await OfflineSalesDatabaseService.updateSyncStatus(
          localId: offlineOrder.localId,
          status: SyncStatus.failed,
          error: 'Order validation failed',
        );
        return SyncResult.failure('Order validation failed');
      }

      // Mark order as syncing
      await OfflineSalesDatabaseService.updateSyncStatus(
        localId: offlineOrder.localId,
        status: SyncStatus.syncing,
      );

      // Create sales checkout params
      final checkoutParams = SalesCheckoutParams(orders: [offlineOrder.order]);

      // Make API call to create the order
      final response = await apiService.postWithAuth(
        url: "/api/v1/merchants/sales-orders",
        body: checkoutParams.toJson(),
      );

      if (response.success) {
        // Extract server ID from response
        String? serverId;
        if (response.data != null && response.data['data'] != null) {
          final orderData = response.data['data'];
          if (orderData is List && orderData.isNotEmpty) {
            serverId = orderData[0]['id']?.toString();
          } else if (orderData is Map) {
            serverId = orderData['id']?.toString();
          }
        }

        // Update order as synced
        await OfflineSalesDatabaseService.updateSyncStatus(
          localId: offlineOrder.localId,
          status: SyncStatus.synced,
          serverId: serverId,
          syncedAt: DateTime.now(),
        );

        printty('Successfully synced order: ${offlineOrder.localId}',
            logName: 'SalesSyncService');
        return SyncResult.success(serverId: serverId);
      } else {
        // Handle sync failure
        await OfflineSalesDatabaseService.updateSyncStatus(
          localId: offlineOrder.localId,
          status: SyncStatus.failed,
          error: response.message ?? 'Unknown error',
        );

        printty(
            'Failed to sync order: ${offlineOrder.localId} - ${response.message}',
            logName: 'SalesSyncService');
        return SyncResult.failure(response.message ?? 'Unknown error');
      }
    } catch (e) {
      // Handle exception
      await OfflineSalesDatabaseService.updateSyncStatus(
        localId: offlineOrder.localId,
        status: SyncStatus.failed,
        error: e.toString(),
      );

      printty('Exception syncing order: ${offlineOrder.localId} - $e',
          logName: 'SalesSyncService');
      return SyncResult.failure(e.toString());
    }
  }

  /// Retry failed orders with exponential backoff
  Future<void> retryFailedOrders() async {
    if (!ConnectivityService.instance.isOnline) {
      printty('Cannot retry: device is offline', logName: 'SalesSyncService');
      return;
    }

    final failedOrders =
        await OfflineSalesDatabaseService.getFailedSyncOrders();
    final retryableOrders =
        failedOrders.where((order) => order.canRetry).toList();

    if (retryableOrders.isEmpty) {
      printty('No retryable orders found', logName: 'SalesSyncService');
      return;
    }

    printty('Retrying ${retryableOrders.length} failed orders',
        logName: 'SalesSyncService');

    for (final order in retryableOrders) {
      // Calculate exponential backoff delay
      final delay = _calculateBackoffDelay(order.retryCount);

      if (order.lastSyncAttempt != null) {
        final timeSinceLastAttempt =
            DateTime.now().difference(order.lastSyncAttempt!);
        if (timeSinceLastAttempt < delay) {
          printty('Skipping order ${order.localId}: backoff period not elapsed',
              logName: 'SalesSyncService');
          continue;
        }
      }

      await _syncSingleOrder(order);

      // Small delay between retries
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  /// Calculate exponential backoff delay
  Duration _calculateBackoffDelay(int retryCount) {
    // Base delay of 1 minute, exponentially increasing
    final baseDelayMinutes = pow(2, retryCount).toInt();
    final maxDelayMinutes = 60; // Maximum 1 hour
    final delayMinutes = min(baseDelayMinutes, maxDelayMinutes);

    return Duration(minutes: delayMinutes);
  }

  /// Force sync all pending orders
  Future<BatchSyncResult> forceSyncAll() async {
    printty('Force sync triggered', logName: 'SalesSyncService');
    return await syncPendingOrders();
  }

  /// Get sync statistics
  Future<SyncStatistics> getSyncStatistics() async {
    final counts = await OfflineSalesDatabaseService.getOrderCountsByStatus();
    final lastSyncTime =
        await OfflineSalesDatabaseService.getLastSyncTimestamp();

    return SyncStatistics(
      pendingCount: counts[SyncStatus.pending] ?? 0,
      syncingCount: counts[SyncStatus.syncing] ?? 0,
      syncedCount: counts[SyncStatus.synced] ?? 0,
      failedCount: counts[SyncStatus.failed] ?? 0,
      lastSyncTime: lastSyncTime,
      isSyncing: _isSyncing,
    );
  }

  /// Emit sync event
  void _emitSyncEvent(SyncEvent event) {
    _syncEventController.add(event);
  }

  /// Dispose the service
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    _syncEventController.close();
    _isInitialized = false;
    printty("Sales sync service disposed", logName: 'SalesSyncService');
  }
}

/// Sync event types
class SyncEvent {
  final SyncEventType type;
  final String? message;
  final int? totalOrders;
  final int? processedOrders;
  final int? successCount;
  final int? failureCount;

  SyncEvent._({
    required this.type,
    this.message,
    this.totalOrders,
    this.processedOrders,
    this.successCount,
    this.failureCount,
  });

  factory SyncEvent.started() => SyncEvent._(type: SyncEventType.started);

  factory SyncEvent.progress(
          int total, int processed, int success, int failure) =>
      SyncEvent._(
        type: SyncEventType.progress,
        totalOrders: total,
        processedOrders: processed,
        successCount: success,
        failureCount: failure,
      );

  factory SyncEvent.completed(int success, int failure) => SyncEvent._(
        type: SyncEventType.completed,
        successCount: success,
        failureCount: failure,
      );

  factory SyncEvent.error(String message) =>
      SyncEvent._(type: SyncEventType.error, message: message);
}

enum SyncEventType { started, progress, completed, error }

/// Sync statistics model
class SyncStatistics {
  final int pendingCount;
  final int syncingCount;
  final int syncedCount;
  final int failedCount;
  final DateTime? lastSyncTime;
  final bool isSyncing;

  SyncStatistics({
    required this.pendingCount,
    required this.syncingCount,
    required this.syncedCount,
    required this.failedCount,
    this.lastSyncTime,
    required this.isSyncing,
  });

  int get totalCount => pendingCount + syncingCount + syncedCount + failedCount;
  bool get hasUnsynced => pendingCount > 0 || failedCount > 0;
}
