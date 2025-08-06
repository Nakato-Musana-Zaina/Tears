// lib/widgets/custom_bottom_navbar.dart

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != widget.currentIndex) {
      _controller.forward().then((_) => _controller.reverse());
    }
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primary = Color(0xFF590201);
    final accent = Color(0xFFFEC106);
    final soft = Color(0xFFF8D56C);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: soft.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.help,
            label: "Help",
            isActive: widget.currentIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          _buildNavItem(
            icon: Icons.local_florist,
            label: "Healers",
            isActive: widget.currentIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          _buildNavItem(
            icon: Icons.message,
            label: "Roast",
            isActive: widget.currentIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
          _buildNavItem(
            icon: Icons.location_on,
            label: "Find",
            isActive: widget.currentIndex == 3,
            onTap: () => _onItemTapped(3),
          ),
          _buildNavItem(
            icon: Icons.chat,
            label: "Posts",
            isActive: widget.currentIndex == 4,
            onTap: () => _onItemTapped(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final accent = Color(0xFFFEC106);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: isActive ? 80 : 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? accent : Colors.grey,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? accent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}