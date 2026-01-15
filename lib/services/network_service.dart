import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  NetworkService() {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      final online = result != ConnectivityResult.none;
      _controller.add(online);
    });
  }

  // Stream for Riverpod
  Stream<bool> get onStatusChange async* {
    yield await isConnected; // initial value
    yield* _controller.stream;
  }

  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _controller.close();
  }
}
