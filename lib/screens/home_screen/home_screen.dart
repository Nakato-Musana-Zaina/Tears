// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:tears/widgets/custom_fab.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

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
            colors: isDarkMode
                ? [Color(0xFF121212), Color(0xFF1E1E1E)]
                : [Color(0xFFFFF9E3), Color(0xFFF8D56C).withOpacity(0.2)],
          ),
        ),
        child: Column(
          children: [
            // ====== Curved Header ======
            ClipPath(
              clipper: _BottomWaveClipper(),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, Color(0xFF7A0E0E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
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
                ),
              ),
            ),

            SizedBox(height: 32),

            // ====== Feature Grid ======
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  children: [
                    // 🌿 Traditional Healers
                    _FeatureCard(
                      title: "Traditional Healers",
                      subtitle: "Rooted in Earth, Guided by Ancestors",
                      icon: Icons.local_florist,
                      gradient: [primary, Color(0xFF7A0E0E)],
                      onTap: () => Navigator.pushNamed(context, '/healers'),
                    ),
                    // 🙏 Spiritual Healers
                    _FeatureCard(
                      title: "Spiritual Healers",
                      subtitle: "Elevate Your Spirit, Heal Your Soul",
                      icon: Icons.self_improvement,
                      gradient: [soft, Color(0xFFB2DFDB)],
                      onTap: () => Navigator.pushNamed(context, '/healers'),
                    ),
                    // 💬 Messages
                    _FeatureCard(
                      title: "Roast Your Ex",
                      subtitle: "Turn pain into power with savage roasts",
                      icon: Icons.message,
                      gradient: [accent, Color(0xFFF8D56C)],
                      onTap: () => Navigator.pushNamed(context, '/messages'),
                    ),
                    // 📍 Find Them
                    _FeatureCard(
                      title: "Find Your Person",
                      subtitle: "Track location (with consent)",
                      icon: Icons.location_on,
                      gradient: [Color(0xFF317773), Color(0xFF4A90E2)],
                      onTap: () => Navigator.pushNamed(context, '/location'),
                    ),
                    // 🐝 Chat with Bee
                    _FeatureCard(
                      title: "Talk to Bee",
                      subtitle: "Your AI healing companion",
                      icon: Icons.chat_bubble,
                      gradient: [accent, Color(0xFFF8D56C)],
                      onTap: () => Navigator.pushNamed(context, '/bee'),
                    ),
                    // 📝 Share Story
                    _FeatureCard(
                      title: "Share Your Story",
                      subtitle: "Heal through community",
                      icon: Icons.chat,
                      gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                      onTap: () => Navigator.pushNamed(context, '/create_post'),
                    ),
                  ],
                ),
              ),
            ),

            // ====== Bottom CTA ======
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, soft],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.5),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.pushNamed(context, '/bee'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            "Start with Bee 🐝",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            "Your healing companion is always here",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Need help? Bee is here!")),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ====== Feature Card Widget ======
  Widget _FeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              SizedBox(height: 8),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== Curved Header ======
class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width * 3 / 4, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}