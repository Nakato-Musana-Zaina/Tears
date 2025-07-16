// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thought.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thought _$ThoughtFromJson(Map<String, dynamic> json) => Thought(
  id: (json['id'] as num?)?.toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  user_id: (json['user_id'] as num).toInt(),
);

Map<String, dynamic> _$ThoughtToJson(Thought instance) => <String, dynamic>{
  'id': instance.id,
  'timestamp': instance.timestamp.toIso8601String(),
  'user_id': instance.user_id,
};
