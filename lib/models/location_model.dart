// lib/models/location_model.dart

class LocationModel {
  final String trackingId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationModel({
    required this.trackingId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      trackingId: json['tracking_id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}