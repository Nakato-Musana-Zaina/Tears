// lib/screens/help_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/custom_fab.dart';
import '../messages_screen.dart';

class HelpScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HelpScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create staggered animations for each card
    _animations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * index,
            0.1 * index + 0.5,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guidance'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back',
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.white12),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              for (int i = 0; i < 4; i++)
                AnimatedBuilder(
                  animation: _animations[i],
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animations[i].value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _animations[i].value)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildSection(
                    context: context,
                    index: i,
                    title: _titles[i],
                    imagePath: _images[i],
                    buttonText: 'Start',
                    onPressed: () => Navigator.pushNamed(context, _routes[i]),
                    backgroundColor: _backgroundColors[i],
                    borderColor: _borderColors[i],
                    foregroundColor: _textColors[i],
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Feature coming soon!")),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Data
  final List<String> _titles = [
    'Should we get you some healers.\nTraditional and religious',
    'I can also help in roasting him',
    'Let\'s find him because we can',
    'How about viewing posts. You can also write.',
  ];

  final List<String> _images = [
    'assets/cat_guidance.png',
    'assets/cat_roast.png',
    'assets/cat_location.png',
    'assets/cat_posts.png',
  ];

  final List<String> _routes = ['/healers', '/messages', '/location', '/posts'];

  final List<Color> _backgroundColors = [
    Colors.transparent,
    Color(0xFFF8D56C),
    Color(0xFF590201),
    Color(0xFFFEC106),
  ];

  final List<Color?> _borderColors = [
    Color(0xFF590201), // Thick red border
    null,
    null,
    null,
  ];

  final List<Color> _textColors = [
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.black,
  ];

  Widget _buildSection({
    required BuildContext context,
    required int index,
    required String title,
    required String imagePath,
    required String buttonText,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color? borderColor,
    required Color foregroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: borderColor != null
            ? Border.all(
                color: borderColor,
                width: 4,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Text & Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Semantics(
                        label: title,
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: foregroundColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEC106),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            tapTargetSize: MaterialTapTargetSize.padded,
                          ),
                          child: const Text('Start'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right: Image
                Hero(
                  tag: 'cat_image_$index',
                  child: Image.asset(
                    imagePath,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                    semanticLabel: 'Cat illustration for $title',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}