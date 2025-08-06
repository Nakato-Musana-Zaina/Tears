// lib/screens/create_post_screen.dart

import 'package:flutter/material.dart';
import 'package:tears/services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const CreatePostScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _anonymous = false;
  bool _isPosting = false;
  late AnimationController _heartAnimationController;
  late AnimationController _floatingAnimationController;
  late Animation<double> _heartAnimation;
  late Animation<double> _floatingAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _heartAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _floatingAnimationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _heartAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _heartAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
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
                      "Share Your Story",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section with animated elements
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withOpacity(0.1),
                      soft.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: soft.withOpacity(0.3)),
                ),
                child: Stack(
                  children: [
                    // Floating background elements
                    Positioned(
                      top: 10,
                      right: 20,
                      child: AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: Text("✨", style: TextStyle(fontSize: 20)),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 30,
                      child: AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatingAnimation.value),
                            child: Text("💝", style: TextStyle(fontSize: 16)),
                          );
                        },
                      ),
                    ),
                    // Main content
                    Column(
                      children: [
                        AnimatedBuilder(
                          animation: _heartAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _heartAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: accent.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "💛",
                                  style: TextStyle(fontSize: 40),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Your voice matters",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Share your healing journey and inspire others",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Writing Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: soft.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit, color: primary, size: 20),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Share Your Thoughts",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Enhanced Text Input
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _controller.text.isNotEmpty ? accent : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "What's on your heart today?\n\nShare your story, your struggles, your victories...\nYour words can heal someone else's heart 💛",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            height: 1.4,
                          ),
                          filled: false,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        maxLines: 8,
                        minLines: 5,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        onChanged: (text) {
                          setState(() {}); // Trigger rebuild for border color
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    // Character count with encouraging message
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _controller.text.length > 50 
                              ? "Your story is taking shape! ✨"
                              : _controller.text.length > 20
                                  ? "Keep going! 🌟"
                                  : "Every word matters 💭",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "${_controller.text.length} characters",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Enhanced Anonymous Toggle Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: _anonymous ? accent.withOpacity(0.5) : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _anonymous ? accent.withOpacity(0.2) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _anonymous ? Icons.visibility_off : Icons.visibility,
                            color: _anonymous ? primary : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Privacy Settings",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _anonymous 
                                    ? "Your identity will be hidden 🤫"
                                    : "Your story will show your profile 👤",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          child: Switch(
                            value: _anonymous,
                            onChanged: (value) {
                              setState(() {
                                _anonymous = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: accent,
                            inactiveThumbColor: Colors.grey[400],
                            inactiveTrackColor: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    if (_anonymous) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: accent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Text("🔒", style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Your story will be shared anonymously. No one will know it's from you.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Enhanced Share Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [accent, soft],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isPosting ? null : () async {
                    if (_controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.edit_note, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text("Please write something before sharing."),
                            ],
                          ),
                          backgroundColor: primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _isPosting = true;
                    });

                    try {
                      await PostService.createPost(
                        {'content': _controller.text, 'anonymous': _anonymous},
                        1, // Replace with real user ID from auth
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Text("💛", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Text("Your story has been shared and will inspire others!"),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.error, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text("Failed to post: $e"),
                            ],
                          ),
                          backgroundColor: primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isPosting = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                  ),
                  child: _isPosting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Sharing your story...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("💛", style: TextStyle(fontSize: 18)),
                            SizedBox(width: 8),
                            Text(
                              "Share Healing",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("✨", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 24),

              // Inspirational footer
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: soft.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: soft.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Text("🌟", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Remember: Your story could be the light someone needs in their darkness.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}