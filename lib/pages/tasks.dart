import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample tasks for demonstration
    final List<String> tasks = [
      'Task 1: Complete Flutter project',
      'Task 2: Review code',
      'Task 3: Write documentation',
      'Task 4: Prepare for meeting',
      'Task 5: Deploy application',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              tasks[index],
              style: Theme.of(context).textTheme.bodyLarge, // Use theme text style
            ),
          );
        },
      ),
    );
  }
}
