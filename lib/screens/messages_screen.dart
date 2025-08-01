// lib/screens/messages_screen.dart

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';
import '../widgets/custom_fab.dart';

class MessagesScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const MessagesScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<MessageModel> allMessages = [];
  List<MessageModel> displayedMessages = [];
  List<MessageModel> favorites = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;
  final int pageSize = 8; // Show more messages
  final ScrollController _controller = ScrollController();

  // Search & Filter
  String _searchQuery = '';
  String _selectedCategory = 'all'; // 'all', 'savage', 'anger', etc.
  final TextEditingController _searchController = TextEditingController();

  // Confetti
  late ConfettiController _confettiController;

  // View Mode: All vs Favorites
  bool _showFavorites = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _controller.addListener(_scrollListener);
    _loadMessages();
    _loadFavorites();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    _searchController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await MessageService.getAllMessages();
      final sorted = messages..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        allMessages = sorted;
        _filterMessages();
      });
    } catch (e) {
      final mock = MessageService.getMockMessages();
      setState(() {
        allMessages = mock;
        _filterMessages();
      });
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favs = await MessageService.getFavorites();
      setState(() {
        favorites = favs;
      });
    } catch (e) {
      setState(() {
        favorites = allMessages.where((m) => m.isFavorite).toList();
      });
    }
  }

  void _filterMessages() {
    List<MessageModel> filtered = _showFavorites
        ? favorites
        : allMessages;

    if (_selectedCategory != 'all') {
      filtered = filtered.where((m) => m.category.toLowerCase() == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((m) => m.text.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    setState(() {
      displayedMessages = filtered.take(pageSize).toList();
      currentPage = 1;
      hasMore = filtered.length > pageSize;
    });
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (isLoading || !hasMore) return;
    setState(() {
      isLoading = true;
    });

    final start = currentPage * pageSize;
    final end = start + pageSize;
    final more = (_showFavorites ? favorites : allMessages)
        .where((m) => _selectedCategory == 'all' || m.category == _selectedCategory)
        .where((m) => m.text.toLowerCase().contains(_searchQuery.toLowerCase()))
        .skip(start)
        .take(pageSize)
        .toList();

    if (more.isEmpty) {
      setState(() {
        hasMore = false;
        isLoading = false;
      });
      return;
    }

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          displayedMessages.addAll(more);
          currentPage++;
          if (displayedMessages.length >= allMessages.length) {
            hasMore = false;
          }
          isLoading = false;
        });
      }
    });
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _confettiController.play();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  void _toggleFavorite(MessageModel message) async {
    final success = await MessageService.toggleFavorite(message.id);
    if (success && mounted) {
      setState(() {
        final index = allMessages.indexOf(message);
        if (index != -1) {
          allMessages[index] = message.copyWith(isFavorite: !message.isFavorite);
        }
        if (message.isFavorite) {
          favorites.remove(message);
        } else {
          favorites.add(message);
        }
        _filterMessages();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search messages...",
                    border: InputBorder.none,
                    isDense: true,
                    prefixIcon: Icon(Icons.search, size: 18),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _filterMessages();
                  },
                ),
                // Category Filter Chips
                SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _chip('all', 'All'),
                      _chip('savage', 'Savage'),
                      _chip('anger', 'Anger'),
                      _chip('funny', 'Funny'),
                      _chip('heartbreak', 'Sad'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(_showFavorites ? Icons.message : Icons.favorite),
                onPressed: () {
                  setState(() {
                    _showFavorites = !_showFavorites;
                    _filterMessages();
                  });
                },
                tooltip: _showFavorites ? "Show All" : "Show Favorites",
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                // Messages List
                Expanded(
                  child: displayedMessages.isEmpty && !isLoading
                      ? Center(
                          child: Text(
                            _showFavorites ? "No favorites yet." : "No messages found.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _controller,
                          itemCount: hasMore ? displayedMessages.length + 1 : displayedMessages.length,
                          itemBuilder: (context, index) {
                            if (index == displayedMessages.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final message = displayedMessages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20), // Larger padding
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Message Text (Selectable)
                                      SelectableText(
                                        message.text,
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          height: 1.6,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // Favorite Button
                                          IconButton(
                                            icon: Icon(
                                              message.isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: message.isFavorite ? Colors.red : null,
                                            ),
                                            onPressed: () => _toggleFavorite(message),
                                          ),
                                          // Copy Button (Yellow)
                                          IconButton(
                                            icon: Icon(Icons.content_copy),
                                            color: Color(0xFFFEC106),
                                            onPressed: () => _copyMessage(message.text),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: CustomFloatingActionButton(
            onPressed: () {
              // Example: Add new roast
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("New roast idea? Coming soon!")),
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
        // Confetti
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          particleDrag: 0.05,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          gravity: 0.1,
          shouldLoop: false,
          colors: [Color(0xFFFEC106), Color(0xFF590201), Colors.white],
        ),
      ],
    );
  }

  Widget _chip(String value, String label) {
    bool isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = value;
          });
          _filterMessages();
        },
        backgroundColor: Colors.transparent,
        selectedColor: Color(0xFFF8D56C),
        checkmarkColor: Color(0xFF590201),
        shape: StadiumBorder(side: BorderSide(color: Color(0xFFF8D56C))),
      ),
    );
  }
}