// lib/services/healer_service.dart

import 'dart:convert';                    // ✅ For jsonDecode
import 'package:http/http.dart' as http; // ✅ For http.get
import '../models/healer_model.dart';     // ✅ For HealerModel

class HealerService {
  static const String baseUrl = 'http://localhost:8000'; // Update with your backend IP

  // Fetch all healers
  static Future<List<HealerModel>> getHealers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/healers/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => HealerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load healers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch healers by type: 'traditional' or 'spiritual'
  static Future<List<HealerModel>> getHealersByType(String type) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/healers/type/$type'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => HealerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load $type healers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}