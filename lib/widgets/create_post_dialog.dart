// widgets/create_post_dialog.dart
import 'package:flutter/material.dart';

class CreatePostDialog extends StatefulWidget {
  final Function(String, bool) onCreate;

  const CreatePostDialog({Key? key, required this.onCreate}) : super(key: key);

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _contentController = TextEditingController();
  bool _anonymous = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Post'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _anonymous,
                  onChanged: (val) {
                    setState(() {
                      _anonymous = val ?? false;
                    });
                  },
                ),
                Text('Post anonymously'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              widget.onCreate(_contentController.text, _anonymous);
              Navigator.pop(context);
            }
          },
          child: Text('Post'),
        ),
      ],
    );
  }
}