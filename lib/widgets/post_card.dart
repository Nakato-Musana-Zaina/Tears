// widgets/post_card.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onFlag;

  const PostCard({
    Key? key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onFlag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Posted ${post.createdAt.toLocal().toString().substring(0, 19)}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            PostActions(
              onLike: onLike,
              onComment: onComment,
              onFlag: onFlag,
            ),
          ],
        ),
      ),
    );
  }
}

class PostActions extends StatelessWidget {
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onFlag;

  const PostActions({this.onLike, this.onComment, this.onFlag});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up),
          tooltip: 'Like',
          onPressed: onLike,
        ),
        IconButton(
          icon: Icon(Icons.comment),
          tooltip: 'Comment',
          onPressed: onComment,
        ),
        IconButton(
          icon: Icon(Icons.flag),
          tooltip: 'Flag',
          onPressed: onFlag,
        ),
      ],
    );
  }
}