// lib/services/message_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class MessageService {
  static const String baseUrl = 'https://your-api.example.com'; // Update with real URL
  static const int userId = 1;

  // 🔁 Real API: Get all messages
  static Future<List<MessageModel>> getAllMessages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/messages/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }
    } catch (e) {
      // If API fails, return mock data
      print("API failed, loading mock roasts: $e");
    }

    // ✅ Fallback: Return mock messages (including your 10 roasts)
    return getMockMessages();
  }

  // ✅ New: Mock messages (including your 10 roasts)
  static List<MessageModel> getMockMessages() {
    return [
      // Your 10 savage roasts
      MessageModel(
        id: 1,
        category: 'savage',
        text: "Being in that situationship felt like signing up for stress with no benefits.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 2,
        category: 'savage',
        text: "Confidence was loud, but intelligence never showed up.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 3,
        category: 'savage',
        text: "Mistakes are meant to teach something — this one just wasted time.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 4,
        category: 'savage',
        text: "Talked like a king, moved like a court jester.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 5,
        category: 'savage',
        text: "Energy matched the Wi-Fi in a tunnel — weak, unreliable, and constantly cutting out.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 6,
        category: 'savage',
        text: "Promises sounded nice until the lies showed up in better lighting.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 7,
        category: 'savage',
        text: "Potential doesn’t mean much when laziness leads the way.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 8,
        category: 'savage',
        text: "Dating felt like arguing with a slow-loading webpage.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 9,
        category: 'savage',
        text: "Emotions ran deep — like a kiddie pool.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),
      MessageModel(
        id: 10,
        category: 'savage',
        text: "Red flags came gift-wrapped in fake charm.",
        createdAt: DateTime(2024, 5, 10),
        isFavorite: false,
      ),

      // Add a few more for variety
      MessageModel(
        id: 11,
        category: 'anger',
        text: "You’re not toxic. I am — for still hoping you’d change.",
        createdAt: DateTime(2024, 5, 9),
        isFavorite: true,
      ),
      MessageModel(
        id: 12,
        category: 'funny',
        text: "We’re not incompatible. I just like oxygen.",
        createdAt: DateTime(2024, 5, 8),
        isFavorite: false,
      ),
    ];
  }

  // 🔁 API: Get by category
  static Future<List<MessageModel>> getMessagesByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/messages/category/$category'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback to filtering mock data
    }
    return getMockMessages().where((msg) => msg.category == category).toList();
  }

  // 🔁 API: Toggle favorite
  static Future<bool> toggleFavorite(int messageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages/favorite'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message_id': messageId, 'user_id': userId}),
      );
      return response.statusCode == 200;
    } catch (e) {
      // In mock mode, just pretend it worked
      return true;
    }
  }

  // 🔁 API: Get favorites
  static Future<List<MessageModel>> getFavorites() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/messages/favorites/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback: return favorited mock messages
    }
    return getMockMessages().where((msg) => msg.isFavorite).toList();
  }
}