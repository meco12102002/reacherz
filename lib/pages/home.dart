import 'package:flutter/material.dart';
import 'package:reacher/widgets/module_card.dart';
import 'package:reacher/widgets/modules/module_a.dart';
import 'package:reacher/widgets/modules/module_b.dart';
import 'package:reacher/widgets/modules/module_c.dart';
import 'package:reacher/widgets/modules/module_d.dart';
import 'package:reacher/widgets/modules/module_e.dart';
import 'package:reacher/widgets/modules/module_f.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToModule(BuildContext context, String moduleName) {
    Widget moduleWidget;

    // Navigate to the correct module based on the moduleName
    switch (moduleName) {
      case 'ModuleA':
        moduleWidget = const ModuleA(); // Instantiate Module A
        break;
      case 'ModuleB':
        moduleWidget = const ModuleB(); // Instantiate Module B
        break;
      case 'ModuleC':
        moduleWidget = const ModuleC(); // Instantiate Module C
        break;
      case 'ModuleD':
        moduleWidget = const ModuleD(); // Instantiate Module D
        break;
      case 'ModuleE':
        moduleWidget = const ModuleE(); // Instantiate Module E
        break;
      case 'ModuleF':
        moduleWidget = const ModuleF(); // Instantiate Module F
        break;
      default:
        moduleWidget = const SizedBox(); // Fallback if module not found
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => moduleWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reacher E-Learning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lessons',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16), // Space between title and module cards

              // Horizontally scrollable list of module cards
              SizedBox(
                height: 160, // Set height for the card container
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToModule(context, 'ModuleA'),
                      child: const ModuleCard(
                        title: 'Module A',
                        description: 'Learn about the letter A',
                        imageUrl: 'assets/images/A.png',
                        moduleName: 'ModuleA',
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards
                    GestureDetector(
                      onTap: () => _navigateToModule(context, 'ModuleB'),
                      child: const ModuleCard(
                        title: 'Module B',
                        description: 'Learn about the letter B',
                        imageUrl: 'assets/images/B.png',
                          moduleName: 'ModuleB'
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards
                    GestureDetector(
                      onTap: () => _navigateToModule(context, 'ModuleC'),
                      child: const ModuleCard(
                        title: 'Module C',
                        description: 'Learn about the letter C',
                        imageUrl: 'assets/images/C.png',
                          moduleName: 'ModuleC'
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards
                    GestureDetector(
                      onTap: () => _navigateToModule(context, 'ModuleD'),
                      child: const ModuleCard(
                        title: 'Module D',
                        description: 'Learn about the letter D',
                        imageUrl: 'assets/images/D.png',
                          moduleName: 'ModuleD'
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards
                    GestureDetector(
                      onTap: () => _navigateToModule(context, 'ModuleE'),
                      child: const ModuleCard(
                        title: 'Module E',
                        description: 'Learn about the letter E',
                        imageUrl: 'assets/images/E.png',
                          moduleName: 'ModuleE'

                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards
                    GestureDetector(
                      onTap: () => _navigateToModule(context, 'ModuleF'),
                      child: const ModuleCard(
                        title: 'Module F',
                        description: 'Learn about the letter F',
                        imageUrl: 'assets/images/F.png',
                          moduleName: 'ModuleF'
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Space after the cards
              // Add more content here as needed without overflowing
            ],
          ),
        ),
      ),
    );
  }
}
