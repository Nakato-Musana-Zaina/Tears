// lib/screens/messages_screen.dart
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';
import '../widgets/savage_message_card.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<MessageModel> messages = [];
  List<MessageModel> filteredMessages = [];
  String selectedCategory = 'all';
  bool isLoading = true;

  final List<String> categories = ['all', 'good', 'blasting', 'peaceful'];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => isLoading = true);
    final allMessages = await MessageService.getAllMessages();
    setState(() {
      messages = allMessages;
      filteredMessages = allMessages;
      isLoading = false;
    });
  }

  void _filterMessages(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'all') {
        filteredMessages = messages;
      } else {
        filteredMessages = messages.where((m) => m.category == category).toList();
      }
    });
  }

  void _toggleFavorite(MessageModel message) async {
    final success = await MessageService.toggleFavorite(message.id);
    if (success) {
      setState(() {
        int index = messages.indexWhere((m) => m.id == message.id);
        if (index >= 0) {
          messages[index] = message.copyWith(isFavorite: !message.isFavorite);
        }
        int filteredIndex = filteredMessages.indexWhere((m) => m.id == message.id);
        if (filteredIndex >= 0) {
          filteredMessages[filteredIndex] = message.copyWith(isFavorite: !message.isFavorite);
        }
      });
    }
  }

  void _copyMessage(String text) {
    // You can implement clipboard copy here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savage Roasts'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category.toUpperCase()),
                    selected: isSelected,
                    onSelected: (_) => _filterMessages(category),
                    selectedColor: const Color(0xFF8B1538).withOpacity(0.2),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredMessages.isEmpty
                    ? const Center(child: Text('No messages found.'))
                    : ListView.builder(
                        itemCount: filteredMessages.length,
                        itemBuilder: (context, index) {
                          final message = filteredMessages[index];
                          return SavageMessageCard(
                            message: message,
                            onFavorite: () => _toggleFavorite(message),
                            onCopy: () => _copyMessage(message.text),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}