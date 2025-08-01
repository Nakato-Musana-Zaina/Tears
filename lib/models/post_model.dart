// models/post_model.dart
class Post {
  final int id;
  final String content;
  final bool anonymous;
  final int userId;
  final DateTime createdAt;
  final bool approved;

  Post({
    required this.id,
    required this.content,
    required this.anonymous,
    required this.userId,
    required this.createdAt,
    required this.approved,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      anonymous: json['anonymous'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      approved: json['approved'],
    );
  }
}