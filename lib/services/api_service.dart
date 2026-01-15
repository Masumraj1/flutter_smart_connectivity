import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/post.dart';

class ApiService {
  Future<List<Post>> fetchPosts() async {
    final res = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    final List data = json.decode(res.body);
    return data.map((e) => Post.fromJson(e)).toList();
  }
}
