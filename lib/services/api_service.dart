// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/thought.dart';

class ApiService {
  static const String baseUrl = 'http://YOUR_BACKEND_URL'; // replace with your backend URL

  // Log a thought
  static Future<Thought?> logThought(Thought thought) async {
    try {
      final url = Uri.parse('$baseUrl/thoughts/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(thought.toJson()),
      );
      if (response.statusCode == 201) {
        return Thought.fromJson(jsonDecode(response.body));
      } else {
        print('Error logging thought: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Network error logging thought: $e');
      return null;
    }
  }

  // Get thoughts by user
  static Future<List<Thought>> getThoughtsByUser(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/thoughts/logs?user_id=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Thought.fromJson(json)).toList();
      } else {
        print('Error fetching thoughts: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Network error fetching thoughts: $e');
      return [];
    }
  }

  // Get count for today
  static Future<int> getThoughtCountToday(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/thoughts/stats?user_id=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['today'] ?? 0;
      } else {
        print('Error fetching today count: ${response.body}');
        return 0;
      }
    } catch (e) {
      print('Network error fetching today count: $e');
      return 0;
    }
  }

  // Get motivational message
  static Future<String> getMotivationalMessage(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/thoughts/motivational?user_id=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Stay strong!';
      } else {
        print('Error fetching message: ${response.body}');
        return 'Stay strong!';
      }
    } catch (e) {
      print('Network error fetching message: $e');
      return 'Stay strong!';
    }
  }
}