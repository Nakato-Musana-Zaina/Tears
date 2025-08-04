// lib/screens/first_page.dart

import 'package:flutter/material.dart';
import '../widgets/custom_fab.dart';
import 'home_screen.dart';
import 'help_screen.dart';

class FirstPage extends StatelessWidget {
  final dynamic toggleTheme;
  
  final dynamic isDarkMode;

  const FirstPage({Key? key,required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF590201), // Dark red
        title: const Text('Pet Name Generator'),
        elevation: 0,
        // Make title white (already default with dark background)
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title - on white background, but dark text is fine
              Text(
                'Give that excuse of a human a pet-name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF590201), // Dark red text
                ),
              ),

              const SizedBox(height: 20),

              // Cat Image
              Image.asset(
                '/home/nakato/tears/assets/Cat_unpleasant.png',
                width: 180,
                height: 180,
              ),

              const SizedBox(height: 30),

              // Dropdown Button - wrapped in SizedBox to control width
              SizedBox(
                width: 240, // Narrow dropdown
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8D56C), // Soft yellow
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: null,
                    items: const [
                      DropdownMenuItem(
                        value: 'Discount Romeo',
                        child: Text('Discount Romeo'),
                      ),
                      DropdownMenuItem(
                        value: 'Emotional Goldfish',
                        child: Text('Emotional Goldfish'),
                      ),
                      DropdownMenuItem(
                        value: 'Walking Red Flag',
                        child: Text('Walking Red Flag'),
                      ),
                    ],
                    onChanged: (value) {
                      // Handle selection if needed
                    },
                    hint: const Text(
                      'Select a petname...',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    underline: Container(),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Suggestions Title - now white if background changes, but currently on white
              // Let's wrap suggestions in a dark-colored container to show white text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF590201), // Dark red background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Here are a few suggestions for you:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ✅ White text on dark
                  ),
                ),
              ),

              const SizedBox(height: 9),

              // Suggestions List - also on dark theme
              _buildSuggestion('> Discount Romeo'),
              _buildSuggestion('> Emotional Goldfish'),
              _buildSuggestion('> Walking Red Flag'),

              const SizedBox(height: 30),

              // Buttons: Skip & Continue - compact width
              Row(
                mainAxisSize: MainAxisSize.min, // Shrink row to content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Skip Button - Dark red (app bar color)
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF590201), // Same as app bar
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('SKIP'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Continue Button - Yellow
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/anger');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEC106),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('CONTINUE'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // ✅ FAB on the LEFT side
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Feature coming soon!")),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Reusable suggestion item with dark background and white text
  Widget _buildSuggestion(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF590201),
          fontSize: 14,
        ),
      ),
    );
  }
}