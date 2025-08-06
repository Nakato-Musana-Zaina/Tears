// lib/screens/post_list_screen.dart

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:confetti/confetti.dart';
import 'package:tears/models/post_model.dart';
import 'package:tears/services/post_service.dart';
import 'package:tears/widgets/custom_fab.dart';


class PostListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const PostListScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> with TickerProviderStateMixin {
  late Future<List<Post>> _postsFuture;
  final RefreshController _refreshController = RefreshController();
  final List<ConfettiController> _confettiControllers = [];

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService.fetchPosts();
    // Pre-create confetti controllers
    for (int i = 0; i < 20; i++) {
      _confettiControllers.add(ConfettiController(duration: Duration(seconds: 3)));
    }
  }

  @override
  void dispose() {
    for (var controller in _confettiControllers) {
      controller.dispose();
    }
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      final data = await PostService.fetchPosts();
      if (mounted) {
        setState(() {
          _postsFuture = Future.value(data);
        });
      }
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLike(Post post, int index) async {
    try {
      final newCount = await PostService.likePost(post.id, 1); // Replace 1 with real user ID
      if (mounted) {
        setState(() {
          _confettiControllers[index].play();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You liked a post 💛")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to like")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Color(0xFF590201);
    final accent = Color(0xFFFEC106);
    final soft = Color(0xFFF8D56C);
    final isDarkMode = widget.isDarkMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, Color(0xFF7A0A02)],
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Community Healing",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                      ),
                      onPressed: widget.toggleTheme,
                      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: accent));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 60, color: soft),
                    SizedBox(height: 16),
                    Text(
                      "No stories yet",
                      style: TextStyle(fontSize: 18, color: primary),
                    ),
                    Text(
                      "Be the first to share your healing journey 💛",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final posts = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final confetti = _confettiControllers[index % _confettiControllers.length];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    children: [
                      // Confetti
                      ConfettiWidget(
                        confettiController: confetti,
                        blastDirectionality: BlastDirectionality.explosive,
                        particleDrag: 0.05,
                        emissionFrequency: 0.05,
                        numberOfParticles: 15,
                        gravity: 0.1,
                        shouldLoop: false,
                        colors: [accent, soft, Colors.white],
                      ),
                      // Post Card
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                          border: Border.all(color: soft.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: post.anonymous ? soft : primary,
                                    radius: 16,
                                    child: Text(
                                      post.anonymous ? "👤" : "${post.userId}",
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.anonymous ? "Anonymous" : "User ${post.userId}",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                          post.timeAgo,
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: SelectableText(
                                post.content,
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ),
                            // Actions
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Row(
                                children: [
                                  // Like
                                  GestureDetector(
                                    onTap: () => _onLike(post, index),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.favorite_border,
                                          size: 18,
                                          color: primary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${post.likeCount}",
                                          style: TextStyle(fontSize: 14, color: primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  // Comment
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "${post.commentCount}",
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createpost');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}