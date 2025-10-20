import 'dart:async';
import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Enum for different connectivity states
enum ConnectivityState {
  online,
  offline,
  unknown,
}

/// Service for monitoring network connectivity
class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._();

  ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Stream controllers for connectivity state
  final StreamController<ConnectivityState> _connectivityStateController =
      StreamController<ConnectivityState>.broadcast();

  final StreamController<bool> _isOnlineController =
      StreamController<bool>.broadcast();

  ConnectivityState _currentState = ConnectivityState.unknown;
  bool _isOnline = false;
  DateTime? _lastConnectivityChange;
  Timer? _connectivityCheckTimer;

  /// Stream of connectivity state changes
  Stream<ConnectivityState> get connectivityStateStream =>
      _connectivityStateController.stream;

  /// Stream of online/offline status
  Stream<bool> get isOnlineStream => _isOnlineController.stream;

  /// Current connectivity state
  ConnectivityState get currentState => _currentState;

  /// Current online status
  bool get isOnline => _isOnline;

  /// Last time connectivity changed
  DateTime? get lastConnectivityChange => _lastConnectivityChange;

  /// Initialize the connectivity service
  Future<void> initialize() async {
    try {
      // Check initial connectivity
      await _checkConnectivity();

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          printty('Connectivity stream error: $error',
              logName: 'ConnectivityService');
        },
      );

      // Set up periodic connectivity checks
      _startPeriodicConnectivityCheck();

      printty("===> Connectivity service initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'ConnectivityService initialize');
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) async {
    printty('Connectivity changed: $results', logName: 'ConnectivityService');
    await _checkConnectivity();
  }

  /// Check current connectivity and update state
  Future<void> _checkConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      final hasConnection = _hasNetworkConnection(connectivityResults);

      // Perform actual internet connectivity test
      bool isActuallyOnline = false;
      if (hasConnection) {
        isActuallyOnline = await _testInternetConnectivity();
      }

      final newState = isActuallyOnline
          ? ConnectivityState.online
          : ConnectivityState.offline;

      if (newState != _currentState) {
        final previousState = _currentState;
        _currentState = newState;
        _isOnline = isActuallyOnline;
        _lastConnectivityChange = DateTime.now();

        // Emit state changes
        _connectivityStateController.add(_currentState);
        _isOnlineController.add(_isOnline);

        printty(
            'Connectivity state changed: ${previousState.name} -> ${newState.name}',
            logName: 'ConnectivityService');

        // Handle connectivity state changes
        await _handleConnectivityStateChange(previousState, newState);

        // Handle network interruption if going offline
        if (previousState == ConnectivityState.online &&
            newState == ConnectivityState.offline) {
          await OfflineRecoveryService.handleNetworkInterruption();
        }
      }
    } catch (e) {
      printty('Error checking connectivity: $e',
          logName: 'ConnectivityService');
      _updateState(ConnectivityState.unknown, false);
    }
  }

  /// Check if there's a network connection based on connectivity results
  bool _hasNetworkConnection(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }

  /// Test actual internet connectivity by making a network request
  Future<bool> _testInternetConnectivity() async {
    try {
      // Try to connect to a reliable host
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      printty('Internet connectivity test failed: $e',
          logName: 'ConnectivityService');
      return false;
    }
  }

  /// Update connectivity state
  void _updateState(ConnectivityState state, bool isOnline) {
    if (state != _currentState || isOnline != _isOnline) {
      _currentState = state;
      _isOnline = isOnline;
      _lastConnectivityChange = DateTime.now();

      _connectivityStateController.add(_currentState);
      _isOnlineController.add(_isOnline);
    }
  }

  /// Handle connectivity state changes
  Future<void> _handleConnectivityStateChange(
    ConnectivityState previousState,
    ConnectivityState newState,
  ) async {
    if (previousState == ConnectivityState.offline &&
        newState == ConnectivityState.online) {
      // Connection restored
      printty('Internet connection restored', logName: 'ConnectivityService');
      await _onConnectionRestored();
    } else if (previousState == ConnectivityState.online &&
        newState == ConnectivityState.offline) {
      // Connection lost
      printty('Internet connection lost', logName: 'ConnectivityService');
      await _onConnectionLost();
    }
  }

  /// Handle connection restored event
  Future<void> _onConnectionRestored() async {
    try {
      // Store connectivity restoration timestamp
      await StorageService.storeStringItem(
        'last_connection_restored',
        DateTime.now().toIso8601String(),
      );

      // Trigger sync if there are pending offline orders
      // This will be handled by the sync service
    } catch (e) {
      printty('Error handling connection restored: $e',
          logName: 'ConnectivityService');
    }
  }

  /// Handle connection lost event
  Future<void> _onConnectionLost() async {
    try {
      // Store connectivity loss timestamp
      await StorageService.storeStringItem(
        'last_connection_lost',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      printty('Error handling connection lost: $e',
          logName: 'ConnectivityService');
    }
  }

  /// Start periodic connectivity checks
  void _startPeriodicConnectivityCheck() {
    _connectivityCheckTimer?.cancel();
    _connectivityCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkConnectivity(),
    );
  }

  /// Stop periodic connectivity checks
  void _stopPeriodicConnectivityCheck() {
    _connectivityCheckTimer?.cancel();
    _connectivityCheckTimer = null;
  }

  /// Force a connectivity check
  Future<void> forceConnectivityCheck() async {
    await _checkConnectivity();
  }

  /// Get connectivity status as a string for UI display
  String get connectivityStatusText {
    switch (_currentState) {
      case ConnectivityState.online:
        return 'Online';
      case ConnectivityState.offline:
        return 'Offline';
      case ConnectivityState.unknown:
        return 'Unknown';
    }
  }

  /// Get connectivity icon name for UI
  String get connectivityIconName {
    switch (_currentState) {
      case ConnectivityState.online:
        return 'wifi';
      case ConnectivityState.offline:
        return 'wifi_off';
      case ConnectivityState.unknown:
        return 'help';
    }
  }

  /// Check if we've been offline for a certain duration
  bool hasBeenOfflineFor(Duration duration) {
    if (_currentState != ConnectivityState.offline ||
        _lastConnectivityChange == null) {
      return false;
    }

    return DateTime.now().difference(_lastConnectivityChange!) >= duration;
  }

  /// Check if we've been online for a certain duration
  bool hasBeenOnlineFor(Duration duration) {
    if (_currentState != ConnectivityState.online ||
        _lastConnectivityChange == null) {
      return false;
    }

    return DateTime.now().difference(_lastConnectivityChange!) >= duration;
  }

  /// Dispose the service
  void dispose() {
    _connectivitySubscription?.cancel();
    _stopPeriodicConnectivityCheck();
    _connectivityStateController.close();
    _isOnlineController.close();
    printty("Connectivity service disposed", logName: 'ConnectivityService');
  }
}
