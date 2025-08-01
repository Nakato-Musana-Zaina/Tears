// // widgets/comment_section.dart
// import 'package:flutter/material.dart';
// import '../models/comment.dart';

// class CommentSection extends StatelessWidget {
//   final List<Comment> comments;
//   final Function(String) onAddComment;

//   const CommentSection({
//     Key? key,
//     required this.comments,
//     required this.onAddComment,
//   }) : super(key: key);

//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text('Comments (${comments.length})'),
//       children: [
//         ...comments.map((comment) => ListTile(
//               title: Text(comment.text),
//               subtitle: Text('User ${comment.userId} on ${comment.createdAt.toLocal().toString().substring(0, 19)}'),
//             )),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: 'Add a comment...',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {
//                   if (_controller.text.isNotEmpty) {
//                     onAddComment(_controller.text);
//                     _controller.clear();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }