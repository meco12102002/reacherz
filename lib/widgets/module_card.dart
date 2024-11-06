import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String moduleName;

  const ModuleCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.moduleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add shadow for better aesthetics
      child: Container(
        width: 120, // Fixed width for the card
        height: 160, // Increased height to accommodate text
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space items evenly
          children: [
            Image.asset(
              imageUrl,
              height: 80, // Constrained image height
              fit: BoxFit.cover,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
