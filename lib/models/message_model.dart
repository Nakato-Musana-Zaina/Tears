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

  // ✅ NEW: Getter to map category to relevant icons
List<IconData> get icons {
  switch (category.toLowerCase()) {
    case 'anger':
    case 'angry':
      return [Icons.sentiment_very_dissatisfied, Icons.gpp_bad];
    case 'savage':
    case 'roast':
      return [Icons.flash_on, Icons.cruelty_free]; // 💥 + 🐾
    case 'sad':
    case 'heartbreak':
      return [Icons.sentiment_dissatisfied, Icons.broken_image];
    case 'funny':
    case 'sarcastic':
      return [Icons.sentiment_very_satisfied, Icons.emoji_emotions];
    // case 'toxic':
    //   return [Icons.skull, Icons.radio_button_checked];
    default:
      return [Icons.message];
  }
}

  // ✅ Optional: Getter for a friendly category label
  String get displayCategory {
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }
}