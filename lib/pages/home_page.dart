import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/network_status_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔹 Listen network changes
    ref.listen<AsyncValue<bool>>(networkStatusProvider, (prev, next) async {
      next.whenData((online) async {
        final actuallyOnline = await ref.read(networkServiceProvider).isConnected;

        if (!actuallyOnline) {
          // ❌ Offline
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'PLEASE CONNECT TO THE INTERNET',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              duration: const Duration(days: 1),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.fixed,
            ),
          );
        } else {
          // ✅ Online
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'You are connected to the internet',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green[400],
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Offline-Online Example')),
      body: const Center(child: Text('Your main app content here')),
    );
  }
}
