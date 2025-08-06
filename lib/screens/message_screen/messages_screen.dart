// lib/screens/messages_screen.dart

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/message_model.dart';
import '../../services/message_service.dart';
import '../../widgets/custom_fab.dart';

class MessagesScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const MessagesScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with TickerProviderStateMixin {
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

  // Animation controllers for enhanced UI
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _controller.addListener(_scrollListener);
    
    // Initialize animation controller
    _searchAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
    
    _loadMessages();
    _loadFavorites();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    _searchController.dispose();
    _confettiController.dispose();
    _searchAnimationController.dispose();
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
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text("Copied to clipboard!"),
          ],
        ),
        backgroundColor: Color(0xFF590201),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
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

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        _searchQuery = '';
        _filterMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(_isSearchExpanded ? 140 : 100),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF590201), // Dark red
                    Color(0xFF7A0A02), // Slightly lighter dark red
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF590201).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Top row with back button, title, and action buttons
                      Row(
                        children: [
                          // Back button with enhanced design
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
                          // Title
                          Expanded(
                            child: Text(
                              _showFavorites ? 'Favorite Messages' : 'All Messages',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Search toggle button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isSearchExpanded ? Icons.close : Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: _toggleSearch,
                            ),
                          ),
                          SizedBox(width: 8),
                          // Favorites toggle button
                          Container(
                            decoration: BoxDecoration(
                              color: _showFavorites 
                                  ? Color(0xFFFEC106).withOpacity(0.9)
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _showFavorites ? Icons.favorite : Icons.favorite_border,
                                color: _showFavorites ? Color(0xFF590201) : Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showFavorites = !_showFavorites;
                                  _filterMessages();
                                });
                              },
                              tooltip: _showFavorites ? "Show All" : "Show Favorites",
                            ),
                          ),
                        ],
                      ),
                      // Animated search bar
                      AnimatedBuilder(
                        animation: _searchAnimation,
                        builder: (context, child) {
                          return SizeTransition(
                            sizeFactor: _searchAnimation,
                            child: Container(
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search messages...",
                                  hintStyle: TextStyle(color: Colors.grey[600]),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  prefixIcon: Icon(Icons.search, color: Color(0xFF590201)),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                            });
                                            _filterMessages();
                                          },
                                        )
                                      : null,
                                ),
                                style: TextStyle(color: Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                  _filterMessages();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              // Category Filter Chips with enhanced design
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _enhancedChip('all', 'All', Icons.message),
                      _enhancedChip('savage', 'Savage', Icons.whatshot),
                      _enhancedChip('anger', 'Anger', Icons.flash_on),
                      _enhancedChip('funny', 'Funny', Icons.sentiment_very_satisfied),
                      _enhancedChip('heartbreak', 'Sad', Icons.sentiment_dissatisfied),
                    ],
                  ),
                ),
              ),
              // Messages List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: displayedMessages.isEmpty && !isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _showFavorites ? Icons.favorite_border : Icons.message_outlined,
                                size: 64,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              SizedBox(height: 16),
                              Text(
                                _showFavorites ? "No favorites yet." : "No messages found.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF590201)),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final message = displayedMessages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).cardColor,
                                        Theme.of(context).cardColor.withOpacity(0.9),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Category badge
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFEC106).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Color(0xFFFEC106).withOpacity(0.5),
                                            ),
                                          ),
                                          child: Text(
                                            message.category.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF590201),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
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
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // Favorite Button
                                            Container(
                                              decoration: BoxDecoration(
                                                color: message.isFavorite 
                                                    ? Colors.red.withOpacity(0.1)
                                                    : Colors.grey.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  message.isFavorite ? Icons.favorite : Icons.favorite_border,
                                                  color: message.isFavorite ? Colors.red : Colors.grey[600],
                                                ),
                                                onPressed: () => _toggleFavorite(message),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            // Copy Button
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFEC106).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.content_copy),
                                                color: Color(0xFF590201),
                                                onPressed: () => _copyMessage(message.text),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          floatingActionButton: CustomFloatingActionButton(
            onPressed: () {
              // Example: Add new roast
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text("New roast idea? Coming soon!"),
                    ],
                  ),
                  backgroundColor: Color(0xFF590201),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
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

  Widget _enhancedChip(String value, String label, IconData icon) {
    bool isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: FilterChip(
          avatar: Icon(
            icon, 
            size: 16, 
            color: isSelected ? Color(0xFF590201) : Colors.grey[600],
          ),
          label: Text(
            label, 
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xFF590201) : Colors.grey[700],
            ),
          ),
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
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? Color(0xFFF8D56C) : Colors.grey[400]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          elevation: isSelected ? 2 : 0,
          pressElevation: 4,
        ),
      ),
    );
  }
}