// services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostService {
  final String baseUrl = 'postgresql://hbhuser:hbhpassword@localhost:5432/hbhdb/api/posts';

  Future<List<Post>> fetchPosts({String? query}) async {
    final url = query == null ? '$baseUrl/' : '$baseUrl/search?query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> createPost(String content, bool anonymous, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': content,
        'anonymous': anonymous,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<void> likePost(int postId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$postId/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }
  }

  // Add other functions: addComment, flagPost, reportPost, etc.
}