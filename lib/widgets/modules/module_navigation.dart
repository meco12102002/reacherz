import 'package:flutter/material.dart';
import 'package:reacher/widgets/modules/modules_page.dart';

class ModuleNavigation extends StatelessWidget {
  const ModuleNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToModules(context),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎨 Phonics Fun Time!',
                style: TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join the adventure and explore fun lessons!',
                style: TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/pusa.gif',
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToModules(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulesPage(),
      ),
    );
  }
}
