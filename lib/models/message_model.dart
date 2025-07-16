// lib/models/message_model.dart
import 'package:flutter/material.dart';

class MessageModel {
  final int id;
  final String category;
  final String text;
  final DateTime createdAt;
  final bool isFavorite;

  MessageModel({
    required this.id,
    required this.category,
    required this.text,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      category: json['category'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  MessageModel copyWith({bool? isFavorite}) {
    return MessageModel(
      id: id,
      category: category,
      text: text,
      createdAt: createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}