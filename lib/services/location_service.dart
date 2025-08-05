// lib/services/location_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  // 🔐 This should be YOUR backend that receives location
  static const String trackingApiUrl = 'https://yourdomain.com/api/log-location';

  // Generate tracking link
  static String generateTrackingLink(String trackingId) {
    return 'https://yourdomain.com/location/$trackingId';
  }

  // Send location to your backend
  static Future<void> sendLocation(String trackingId, double lat, double lng) async {
    await http.post(
      Uri.parse(trackingApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tracking_id': trackingId,
        'latitude': lat,
        'longitude': lng,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }
}