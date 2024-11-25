import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample notifications for demonstration
    final List<String> notifications = [
      'You have a new message!',
      'Your task is due tomorrow.',
      'Your profile has been updated.',
      'You have a new friend request.',
      'Don\'t forget to check your tasks!',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontFamily: 'Baloo', fontSize: 24),
        ),
        backgroundColor: Colors.orangeAccent, // Kid-friendly color
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
              color: Colors.yellow.shade100,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: Icon(
                  Icons.notifications,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                title: Text(
                  notifications[index],
                  style: const TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: const Text(
                  'Tap to read more details.',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                ),
                onTap: () {
                  // Placeholder action for tapping the notification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a placeholder action!')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
