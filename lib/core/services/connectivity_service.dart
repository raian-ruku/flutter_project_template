import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// A singleton service that monitors network connectivity status.
/// Uses connectivity_plus to detect WiFi/mobile data changes and
/// verifies actual internet access by pinging Google DNS.
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;

  /// Stream of connectivity status changes (true = connected, false = disconnected)
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  /// Current connectivity status
  bool get isConnected => _isConnected;

  /// Initialize the connectivity listener
  Future<void> initialize() async {
    // Check initial status with actual internet verification
    await checkConnectivity();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      // When network status changes, verify actual internet access
      await _updateConnectionStatus(results);
    });
  }

  /// Manually check current connectivity status with actual internet verification
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(results);
    return _isConnected;
  }

  /// Check if we have actual internet access by pinging Google DNS
  Future<bool> _hasActualInternetConnection() async {
    try {
      // Try to lookup Google's DNS address to verify actual internet
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    // First check if network interface is available
    final hasNetworkInterface =
        results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);

    bool isConnected = false;

    if (hasNetworkInterface) {
      // Network interface is on, now verify actual internet access
      isConnected = await _hasActualInternetConnection();
    }

    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectionStatusController.add(_isConnected);
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
  }
}
