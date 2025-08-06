// lib/widgets/post_card.dart

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onLiked;

  const PostCard({Key? key, required this.post, this.onLiked}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late ConfettiController _confettiController;
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 1));
    _likeCount = widget.post.likeCount;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });
    if (_isLiked) _confettiController.play();
    widget.onLiked?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Color(0xFF590201);
    final accent = Color(0xFFFEC106);
    final soft = Color(0xFFF8D56C);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Stack(
          children: [
            // Confetti
            ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 10),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.post.anonymous ? soft : primary,
                        radius: 18,
                        child: Text(
                          widget.post.anonymous ? "👤" : "${widget.post.userId}",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.anonymous ? "Anonymous" : "User ${widget.post.userId}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.post.timeAgo,
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Post Content
                  Text(
                    widget.post.content,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  SizedBox(height: 16),
                  // Actions
                  Row(
                    children: [
                      // Like
                      GestureDetector(
                        onTap: _onLike,
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : null,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text("$_likeCount", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Comment
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
                          SizedBox(width: 4),
                          Text("${widget.post.commentCount}", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}