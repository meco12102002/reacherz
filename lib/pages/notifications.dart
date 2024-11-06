import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample notifications for demonstration
    final List<String> notifications = [
      'Notification 1: You have a new message!',
      'Notification 2: Your task is due tomorrow.',
      'Notification 3: Your profile has been updated.',
      'Notification 4: You have a new friend request.',
      'Notification 5: Don\'t forget to check your tasks!',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              notifications[index],
              style: Theme.of(context).textTheme.bodyLarge, // Use theme text style
            ),
          );
        },
      ),
    );
  }
}
