// lib/services/post_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostService {
  // ✅ Replace with your real backend URL
  static const String baseUrl = 'https://yourdomain.com/api';

  // Fetch all posts
  static Future<List<Post>> fetchPosts({int skip = 0, int limit = 10}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts?skip=$skip&limit=$limit'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  // Fetch single post
  static Future<Post> fetchPost(int postId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Post not found');
    }
  }

  // Create post
  static Future<Post> createPost(Map<String, dynamic> postData, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({...postData, 'user_id': userId}),
    );
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  // Like post
  static Future<int> likePost(int postId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/like?user_id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['like_count'] ?? 0;
    } else {
      throw Exception('Failed to like post');
    }
  }

  // Add comment
  static Future<void> addComment(int postId, String text, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/comment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text, 'user_id': userId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }
}