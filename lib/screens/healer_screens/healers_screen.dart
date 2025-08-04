// lib/screens/healers_screen.dart

import 'package:flutter/material.dart';
import 'package:tears/widgets/custom_fab.dart';
import 'traditional_healers_screen.dart';
import 'spiritual_healers_screen.dart';
import 'bee_chat_screen.dart';

class HealersScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HealersScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // ====== Curved Header ======
            ClipPath(
              clipper: _BottomWaveClipper(),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF590201), Color(0xFF7A0E0E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Choose Your Path",
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

            SizedBox(height: 24),

            // ====== Central Icon (Shared) ======
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFF8D56C),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF8D56C).withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.spa,
                size: 60,
                color: Color(0xFF590201),
              ),
            ),

            SizedBox(height: 12),

            Text(
              "Healing starts here",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 32),

            // ====== Dual Cards: Traditional (Left) & Spiritual (Right) ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // 🌿 Traditional Healer Card
                  Expanded(
                    child: _buildCard(
                      context: context,
                      title: "Traditional Healers",
                      slogan: "Rooted in Earth, Guided by Ancestors",
                      icon: Icons.local_florist,
                      backgroundColor: Color(0xFF590201),
                      iconColor: Color(0xFFFEC106),
                      buttonColor: Color(0xFFFEC106),
                      textColor: Colors.white,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TraditionalHealersScreen(
                            toggleTheme: toggleTheme,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // 🙏 Spiritual Healer Card
                  Expanded(
                    child: _buildCard(
                      context: context,
                      title: "Spiritual Healers",
                      slogan: "Elevate Your Spirit, Heal Your Soul",
                      icon: Icons.self_improvement,
                      backgroundColor: Color(0xFFF8D56C),
                      iconColor: Color(0xFF590201),
                      buttonColor: Color(0xFF590201),
                      textColor: Colors.black,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SpiritualHealersScreen(
                            toggleTheme: toggleTheme,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // ====== Bee CTA: Full Width, Captivating ======
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFEC106), Color(0xFFF8D56C)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFEC106).withOpacity(0.5),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BeeChatScreen(
                            toggleTheme: toggleTheme,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.chat_bubble, size: 28, color: Colors.black),
                          SizedBox(height: 6),
                          Text(
                            "TALK TO BEE NOW",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Your AI healing companion is always here",
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
      floatingActionButton: CustomFloatingActionButton(onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String slogan,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Color buttonColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              SizedBox(height: 16),

              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),

              SizedBox(height: 8),

              // Slogan
              Text(
                slogan,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 20),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonColor == Color(0xFFFEC106) ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    elevation: 3,
                  ),
                  child: Text("Choose Now", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width * 3 / 4, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}