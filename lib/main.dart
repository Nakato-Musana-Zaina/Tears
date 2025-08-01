// 📄 lib/main.dart
import 'package:flutter/material.dart';
import 'package:tears/screens/messages_screen.dart';
import 'package:tears/screens/pet_name_screen.dart';
import 'package:tears/screens/post_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_screen.dart';

void main() {
  runApp(const TearsApp());
}

class TearsApp extends StatelessWidget {
  const TearsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tears',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFF8B1538),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B1538),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8B1538),
          secondary: Color(0xFFE85A4F),
          tertiary: Color(0xFFFFB347),
          background: Color(0xFFFFF8F0),
          surface: Colors.white,
        ),
      ),
      // home: const HomeScreen(),
      // home: const MessagesScreen(),
        home: PostScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
