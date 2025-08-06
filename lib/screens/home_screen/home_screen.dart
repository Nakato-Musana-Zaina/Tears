// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:tears/widgets/custom_fab.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _floatingAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _headerAnimationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _floatingAnimationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));
    
    // Start card animation
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Color(0xFF590201);
    final accent = Color(0xFFFEC106);
    final soft = Color(0xFFF8D56C);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDarkMode
                ? [Color(0xFF121212), Color(0xFF1E1E1E)]
                : [Color(0xFFFFF9E3), Color(0xFFF8D56C).withOpacity(0.2)],
          ),
        ),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // ====== Enhanced App Bar ======
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Animated Header Background
                    ClipPath(
                      clipper: _BottomWaveClipper(),
                      child: AnimatedBuilder(
                        animation: _headerAnimation,
                        builder: (context, child) {
                          return Container(
                            height: 280,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primary, Color(0xFF7A0E0E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Floating decorative elements
                    Positioned(
                      top: 80,
                      right: 30,
                      child: AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text("✨", style: TextStyle(fontSize: 24)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    Positioned(
                      top: 120,
                      left: 40,
                      child: AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatingAnimation.value),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text("💛", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Main title with better positioning
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "🐝",
                                  style: TextStyle(fontSize: 40),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Your Healing Journey",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 6)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Find peace, healing, and your path forward",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                      ),
                      onPressed: widget.toggleTheme,
                    ),
                  ),
                ),
              ],
            ),
            
            // ====== Feature Grid ======
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 32, 20, 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildListDelegate([
                  // Enhanced Feature Cards with staggered animation
                  AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value,
                        child: _EnhancedFeatureCard(
                          title: "Traditional Healers",
                          subtitle: "Rooted in Earth, Guided by Ancestors",
                          icon: Icons.local_florist,
                          emoji: "🌿",
                          gradient: [primary, Color(0xFF7A0E0E)],
                          onTap: () => Navigator.pushNamed(context, '/healers'),
                        ),
                      );
                    },
                  ),
                  
                  AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value * 0.9 + 0.1,
                        child: _EnhancedFeatureCard(
                          title: "Spiritual Healers",
                          subtitle: "Elevate Your Spirit, Heal Your Soul",
                          icon: Icons.self_improvement,
                          emoji: "🙏",
                          gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                          onTap: () => Navigator.pushNamed(context, '/healers'),
                        ),
                      );
                    },
                  ),
                  
                  AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value * 0.8 + 0.2,
                        child: _EnhancedFeatureCard(
                          title: "Roast Your Ex",
                          subtitle: "Turn pain into power with savage roasts",
                          icon: Icons.message,
                          emoji: "🔥",
                          gradient: [accent, Color(0xFFF8D56C)],
                          onTap: () => Navigator.pushNamed(context, '/messages'),
                        ),
                      );
                    },
                  ),
                  
                  AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value * 0.7 + 0.3,
                        child: _EnhancedFeatureCard(
                          title: "Find Your Person",
                          subtitle: "Track location (with consent)",
                          icon: Icons.location_on,
                          emoji: "📍",
                          gradient: [Color(0xFF317773), Color(0xFF4A90E2)],
                          onTap: () => Navigator.pushNamed(context, '/location'),
                        ),
                      );
                    },
                  ),
                  
                  AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value * 0.6 + 0.4,
                        child: _EnhancedFeatureCard(
                          title: "Talk to Bee",
                          subtitle: "Your AI healing companion",
                          icon: Icons.chat_bubble,
                          emoji: "🐝",
                          gradient: [accent, Color(0xFFF8D56C)],
                          onTap: () => Navigator.pushNamed(context, '/bee'),
                        ),
                      );
                    },
                  ),
                  
                  AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value * 0.5 + 0.5,
                        child: _EnhancedFeatureCard(
                          title: "Share Your Story",
                          subtitle: "Heal through community",
                          icon: Icons.chat,
                          emoji: "💬",
                          gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                          onTap: () => Navigator.pushNamed(context, '/create_post'),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
            
            // ====== Enhanced Bottom CTA ======
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
              sliver: SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value * 0.5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [accent, soft],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(0.5),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.pushNamed(context, '/bee'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text("🐝", style: TextStyle(fontSize: 28)),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start with Bee",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Your healing companion is always here to listen and guide you",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black.withOpacity(0.7),
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Text("🐝", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text("Need help? Bee is here!"),
                ],
              ),
              backgroundColor: primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ====== Enhanced Feature Card Widget ======
class _EnhancedFeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String emoji;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _EnhancedFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emoji,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_EnhancedFeatureCard> createState() => _EnhancedFeatureCardState();
}

class _EnhancedFeatureCardState extends State<_EnhancedFeatureCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: widget.gradient),
              boxShadow: [
                BoxShadow(
                  color: widget.gradient.first.withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: widget.onTap,
                onTapDown: (_) => _hoverController.forward(),
                onTapUp: (_) => _hoverController.reverse(),
                onTapCancel: () => _hoverController.reverse(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Icon Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(widget.icon, size: 28, color: Colors.white),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.emoji,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      
                      Spacer(),
                      
                      // Title
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      
                      SizedBox(height: 6),
                      
                      // Subtitle
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Action indicator
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Explore",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ====== Enhanced Curved Header ======
class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    
    // Create a more elegant wave
    path.quadraticBezierTo(size.width * 0.25, size.height + 10, size.width * 0.5, size.height - 10);
    path.quadraticBezierTo(size.width * 0.75, size.height - 30, size.width, size.height - 40);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}