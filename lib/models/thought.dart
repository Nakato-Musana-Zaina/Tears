// models/thought.dart
import 'package:json_annotation/json_annotation.dart';

part 'thought.g.dart';

@JsonSerializable()
class Thought {
  final int? id;
  final DateTime timestamp;
  final int user_id;

  Thought({this.id, required this.timestamp, required this.user_id});

  factory Thought.fromJson(Map<String, dynamic> json) => _$ThoughtFromJson(json);
  Map<String, dynamic> toJson() => _$ThoughtToJson(this);
}