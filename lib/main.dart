import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reacher/pages/dashboard.dart';
import 'package:reacher/pages/login.dart';
import 'package:reacher/theme/dark.dart';
import 'package:reacher/theme/light.dart';
import 'package:reacher/widgets/modules/module_b.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      home: const AuthStateChecker(),
    routes: {
      '/moduleB': (context) => const ModuleB(),
    });
  }
}

class AuthStateChecker extends StatelessWidget {
  const AuthStateChecker({super.key}); // Added constructor

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking auth state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in, navigate to Dashboard
          return const Dashboard(); // Added const for performance optimization
        } else {
          // User is not logged in, navigate to LoginPage
          return const LoginPage(); // Added const for performance optimization
        }
      },
    );
  }
}
