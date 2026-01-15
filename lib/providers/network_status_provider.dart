import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/network_service.dart';

// Singleton NetworkService
final networkServiceProvider = Provider<NetworkService>((ref) => NetworkService());

// Network status stream
final networkStatusProvider = StreamProvider<bool>(
      (ref) => ref.read(networkServiceProvider).onStatusChange,
);
