// lib/services/message_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class MessageService {
  static const String baseUrl = 'http://localhost:8000'; // change accordingly
  static const int userId = 1; // mock user ID

  static Future<List<MessageModel>> getAllMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/messages/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<MessageModel>> getMessagesByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/messages/category/$category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    }
    return [];
  }

  static Future<bool> toggleFavorite(int messageId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages/favorite'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message_id': messageId, 'user_id': userId}),
    );
    return response.statusCode == 200;
  }

  static Future<List<MessageModel>> getFavorites() async {
    final response = await http.get(Uri.parse('$baseUrl/messages/favorites/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    }
    return [];
  }
}