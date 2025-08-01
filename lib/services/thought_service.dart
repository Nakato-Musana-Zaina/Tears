// lib/services/thought_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ThoughtService {
  static const String baseUrl = 'postgresql://hbhuser:hbhpassword@localhost:5432/hbhdb'; // Adjust as needed

  // Log a thought
  static Future<bool> logThought(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/thoughts/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    return response.statusCode == 201;
  }

  // Log a thought if not already logged today
  static Future<bool> logThoughtIfNotToday(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/thoughts/today'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    return response.statusCode == 200;
  }

  // Get today's count
  static Future<int> getTodaysThoughtCount(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/thoughts/stats?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['today'] ?? 0;
    }
    return 0;
  }

  // Get weekly count
  static Future<int> getWeeklyThoughtCount(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/thoughts/stats?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['last_7_days'] ?? 0;
    }
    return 0;
  }

  // Get monthly count
  static Future<int> getMonthlyThoughtCount(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/thoughts/stats?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['last_30_days'] ?? 0;
    }
    return 0;
  }

  // Get motivational message
  static Future<String> getMotivationalMessage(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/thoughts/motivational?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? '';
    }
    return '';
  }

    // Fetch overall stats
  static Future<Map<String, int>> getThoughtStats(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/thoughts/stats?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'today': data['today'] ?? 0,
        'last_7_days': data['last_7_days'] ?? 0,
        'last_30_days': data['last_30_days'] ?? 0,
      };
    }
    return {'today': 0, 'last_7_days': 0, 'last_30_days': 0};
  }

  // // Fetch motivational message
  // static Future<String> getMotivationalMessage(int userId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/thoughts/motivational?user_id=$userId'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['message'] ?? '';
  //   }
  //   return '';
  // }
}
