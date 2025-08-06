// lib/models/post_model.dart

import 'package:flutter/material.dart';

class Post {
  final int id;
  final String content;
  final bool anonymous;
  final int userId;
  final DateTime createdAt;
  final bool approved;
  final int likeCount;
  final int commentCount;

  Post({
    required this.id,
    required this.content,
    required this.anonymous,
    required this.userId,
    required this.createdAt,
    required this.approved,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      anonymous: json['anonymous'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      approved: json['approved'],
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'anonymous': anonymous,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'approved': approved,
      'like_count': likeCount,
      'comment_count': commentCount,
    };
  }

  // Relative time: "2h ago", "1d ago"
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return createdAt.toIso8601String().split('T').first;
  }
}