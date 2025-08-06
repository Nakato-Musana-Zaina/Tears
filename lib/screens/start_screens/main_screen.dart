// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:tears/screens/healer_screens/healers_screen.dart';
import 'package:tears/screens/home_screen/home_screen.dart';
import 'package:tears/screens/location_screen/location_screen.dart';
import 'package:tears/screens/message_screen/messages_screen.dart';
import 'package:tears/screens/post_screens/post_list_screen.dart';
import 'package:tears/widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const MainScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      HealersScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      MessagesScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      LocationScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      PostListScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}