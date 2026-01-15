import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_smart_connectivity/providers/network_status_provider.dart';
import '../model/post.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/network_service.dart';

final postProvider =
StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>(
      (ref) => PostNotifier(
    api: ApiService(),
    cache: CacheService(),
    network: ref.read(networkServiceProvider),
  ),
);

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final ApiService api;
  final CacheService cache;
  final NetworkService network;

  PostNotifier({
    required this.api,
    required this.cache,
    required this.network,
  }) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    // 1️⃣ Memory cache থাকলে instantly দেখাও
    final memory = cache.getMemoryCache();
    if (memory != null && memory.isNotEmpty) {
      state = AsyncData(memory);
    }

    // 2️⃣ Internet ON হলে API fetch + cache save
    if (await network.isConnected) {
      await fetchFromApi();
    }
    // 3️⃣ Internet OFF + memory empty → disk cache দেখাও
    else if (state is! AsyncData) {
      final disk = await cache.getDiskCache();
      state = AsyncData(disk);
    }
  }

  Future<void> fetchFromApi() async {
    final posts = await api.fetchPosts();
    await cache.savePosts(posts);
    state = AsyncData(posts);
  }

  // Pull-to-refresh / manual refresh
  Future<void> refresh() async {
    if (!await network.isConnected) return; // Offline হলে skip
    await fetchFromApi();
  }
}
