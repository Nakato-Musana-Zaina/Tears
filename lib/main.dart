// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tears/screens/location_screen.dart';

// Import your screens
import 'screens/pet_name_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/home_screen.dart';
import 'screens/help_screen.dart';
import 'screens/healer_screens/healers_screen.dart';
import 'screens/healer_screens/traditional_healers_screen.dart';
import 'screens/healer_screens/spiritual_healers_screen.dart';
import 'screens/healer_screens/bee_chat_screen.dart';

// ✅ Global variable to store API key
late String? openAiApiKey;

// ✅ 1. Change to Future<void> and add async
Future<void> main() async {
  // ✅ Required before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load .env from assets (required for Web)
  await dotenv.dotenv.load(fileName: "assets/.env");

  // ✅ Read the API key
  openAiApiKey = dotenv.dotenv.env['OPENAI_API_KEY'];

  if (openAiApiKey == null) {
    print('⚠️ Warning: OPENAI_API_KEY not found in assets/.env');
  }

  // ✅ Run the app
  runApp(const TearsApp());
}

class TearsApp extends StatefulWidget {
  const TearsApp({Key? key}) : super(key: key);

  @override
  State<TearsApp> createState() => _TearsAppState();
}

class _TearsAppState extends State<TearsApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tears',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? darkTheme : lightTheme,
      initialRoute: '/location',
      routes: {
        '/petname': (context) => FirstPage(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/home': (context) => HomeScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/messages': (context) => MessagesScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/help': (context) => HelpScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/healers': (context) => HealersScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/spiritualhealers': (context) => SpiritualHealersScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/traditionalhealers': (context) => TraditionalHealersScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/bee': (context) => BeeChatScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
        '/location': (context) => LocationScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),

      },
    );
  }

  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(primary: Color(0xFF590201), secondary: Color(0xFFFEC106)),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF590201)),
      titleTextStyle: TextStyle(color: Color(0xFF590201), fontSize: 18, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFEC106),
      foregroundColor: Colors.black,
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(primary: Color(0xFFF8D56C), secondary: Color(0xFFFEC106)),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFF8D56C)),
      titleTextStyle: TextStyle(color: Color(0xFFF8D56C), fontSize: 18, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1E1E1E),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFEC106),
      foregroundColor: Colors.black,
    ),
  );
}