import 'dart:async';

import 'package:builders_konnect/core/core.dart';

/// ViewModel for managing connectivity and offline mode state
class ConnectivityViewModel extends BaseVm {
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<SyncEvent>? _syncEventSubscription;

  bool _isOnline = true;
  bool _isSyncing = false;
  SyncStatistics? _syncStats;
  String? _lastSyncError;

  /// Current connectivity state
  bool get isOnline => _isOnline;

  /// Whether sync is currently in progress
  bool get isSyncing => _isSyncing;

  /// Current sync statistics
  SyncStatistics? get syncStats => _syncStats;

  /// Last sync error message
  String? get lastSyncError => _lastSyncError;

  /// Whether there are unsynced orders
  bool get hasUnsyncedOrders => _syncStats?.hasUnsynced ?? false;

  /// Total count of unsynced orders
  int get unsyncedCount =>
      (_syncStats?.pendingCount ?? 0) + (_syncStats?.failedCount ?? 0);

  /// Initialize the connectivity view model
  void initialize() {
    _initializeConnectivity();
    _initializeSyncMonitoring();
    _loadSyncStatistics();
  }

  /// Initialize connectivity monitoring
  void _initializeConnectivity() {
    try {
      // Get initial connectivity state
      _isOnline = ConnectivityService.instance.isOnline;

      // Listen to connectivity changes
      _connectivitySubscription =
          ConnectivityService.instance.isOnlineStream.listen(
        (isOnline) {
          if (_isOnline != isOnline) {
            _isOnline = isOnline;
            notifyListeners();

            // Log connectivity change
            printty('Connectivity changed: ${isOnline ? 'Online' : 'Offline'}',
                logName: 'ConnectivityViewModel');

            // Refresh sync stats when coming online
            if (isOnline) {
              _loadSyncStatistics();
            }
          }
        },
        onError: (error) {
          printty('Connectivity stream error: $error',
              logName: 'ConnectivityViewModel');
        },
      );
    } catch (e) {
      printty('Error initializing connectivity: $e',
          logName: 'ConnectivityViewModel');
    }
  }

  /// Initialize sync event monitoring
  void _initializeSyncMonitoring() {
    try {
      _syncEventSubscription = SalesSyncService.instance.syncEventStream.listen(
        (event) {
          _handleSyncEvent(event);
        },
        onError: (error) {
          printty('Sync event stream error: $error',
              logName: 'ConnectivityViewModel');
        },
      );
    } catch (e) {
      printty('Error initializing sync monitoring: $e',
          logName: 'ConnectivityViewModel');
    }
  }

  /// Handle sync events
  void _handleSyncEvent(SyncEvent event) {
    switch (event.type) {
      case SyncEventType.started:
        _isSyncing = true;
        _lastSyncError = null;
        notifyListeners();
        break;

      case SyncEventType.progress:
        // Sync is still in progress, no state change needed
        break;

      case SyncEventType.completed:
        _isSyncing = false;
        _lastSyncError = null;
        _loadSyncStatistics(); // Refresh stats after completion
        notifyListeners();
        break;

      case SyncEventType.error:
        _isSyncing = false;
        _lastSyncError = event.message;
        notifyListeners();
        break;
    }
  }

  /// Load current sync statistics
  Future<void> _loadSyncStatistics() async {
    try {
      _syncStats = await SalesSyncService.instance.getSyncStatistics();
      notifyListeners();
    } catch (e) {
      printty('Error loading sync statistics: $e',
          logName: 'ConnectivityViewModel');
    }
  }

  /// Trigger manual sync
  Future<bool> triggerManualSync() async {
    if (!_isOnline) {
      _lastSyncError = 'Cannot sync while offline';
      notifyListeners();
      return false;
    }

    if (_isSyncing) {
      _lastSyncError = 'Sync already in progress';
      notifyListeners();
      return false;
    }

    try {
      _lastSyncError = null;
      notifyListeners();

      final result = await SalesSyncService.instance.forceSyncAll();

      // Refresh stats after sync
      await _loadSyncStatistics();

      return result.allSuccessful;
    } catch (e) {
      _lastSyncError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Refresh connectivity and sync state
  Future<void> refresh() async {
    _isOnline = ConnectivityService.instance.isOnline;
    await _loadSyncStatistics();
    notifyListeners();
  }

  /// Get connectivity status display text
  String get connectivityStatusText {
    if (_isSyncing) {
      return 'Syncing...';
    } else if (_isOnline) {
      if (hasUnsyncedOrders) {
        return 'Online - $unsyncedCount unsynced';
      } else {
        return 'Online';
      }
    } else {
      return 'Offline';
    }
  }

  /// Get connectivity status color
  Color get connectivityStatusColor {
    if (_isSyncing) {
      return AppColors.yellowE6;
    } else if (_isOnline) {
      if (hasUnsyncedOrders) {
        return AppColors.yellow6;
      } else {
        return AppColors.green1A;
      }
    } else {
      return AppColors.red2D;
    }
  }

  /// Check if manual sync is available
  bool get canManualSync => _isOnline && !_isSyncing && hasUnsyncedOrders;

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncEventSubscription?.cancel();
    super.dispose();
  }
}

final connectivityViewModelProvider =
    ChangeNotifierProvider<ConnectivityViewModel>((ref) {
  final vm = ConnectivityViewModel();
  vm.initialize();
  return vm;
});
