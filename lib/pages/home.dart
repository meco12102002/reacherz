import 'package:flutter/material.dart';
import 'package:reacher/widgets/modules/module_navigation.dart'; // Import the new module navigation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to stop the music before navigating to another screen
  void _stopMusicAndNavigate(Widget targetPage) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      body: Stack(
        children: [
          // Background decoration
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF85D8CE), Color(0xFF085078)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Header
                  ScaleTransition(
                    scale: Tween(begin: 1.0, end: 1.1).animate(_animationController),
                    child: Center(
                      child: Image.asset(
                        'assets/images/kids_learning.png',
                        height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '🎉 Welcome to Reacher 🎉',
                    style: TextStyle(
                      fontFamily: 'ComicSans',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4.0,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      _stopMusicAndNavigate(ModuleNavigation());
                    },
                    child: const Text(
                      'Navigate to Modules',
                      style: TextStyle(
                        fontFamily: 'ComicSans',
                        fontSize: 20,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  ModuleNavigation(), // Use the navigation module
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
