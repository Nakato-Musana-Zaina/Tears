// screens/post_screen.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
// import '../widgets/comment_section.dart';
import '../widgets/create_post_dialog.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostService _postService = PostService();
  List<Post> _posts = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    setState(() {
      _loading = true;
    });
    try {
      final posts = await _postService.fetchPosts(query: _searchQuery.isEmpty ? null : _searchQuery);
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      // handle error
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onSearch(String query) {
    _searchQuery = query;
    fetchPosts();
  }

  void _createPost() async {
    // Implement post creation dialog or screen
    String content = 'Sample post content'; // Replace with actual input
    bool anonymous = false; // Replace with user input
    int userId = 1; // Replace with current user id
    await _postService.createPost(content, anonymous, userId);
    fetchPosts();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Posts'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        child: Icon(Icons.add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return PostCard(post: post);
              },
            ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
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
            Text('Posted on ${post.createdAt.toLocal()}'),
            // Add buttons for like, comment, flag, etc.
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    // Call like function
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Show comment section
                  },
                ),
                IconButton(
                  icon: Icon(Icons.flag),
                  onPressed: () {
                    // Flag post
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}