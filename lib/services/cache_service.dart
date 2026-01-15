import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/post.dart';

class CacheService {
  static const _key = 'cached_posts';
  List<Post>? _memoryCache;

  // 🔹 memory cache instant data দেখানোর জন্য
  List<Post>? getMemoryCache() => _memoryCache;

  // 🔹 Save posts both memory & disk
  Future<void> savePosts(List<Post> posts) async {
    _memoryCache = posts;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, json.encode(posts.map((e) => e.toJson()).toList()));
  }

  // 🔹 Disk cache load
  Future<List<Post>> getDiskCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List data = json.decode(jsonString);
    return data.map((e) => Post.fromJson(e)).toList();
  }
}
