import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FullMessagesScreen extends StatefulWidget {
  const FullMessagesScreen({Key? key}) : super(key: key);

  @override
  _FullMessagesScreenState createState() => _FullMessagesScreenState();
}

class _FullMessagesScreenState extends State<FullMessagesScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;

  // Change this to your actual backend API URL
  final String apiUrl = 'http://127.0.0.1:8000/messages/'; // for emulator

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          messages = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load messages");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(
                      message['text'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${message['category']}"),
                        Text("Likes: ${message['favorites_count']}"),
                        Text("Liked by: ${message['favorited_by_users'].join(', ')}"),
                        Text("Created at: ${message['created_at']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
