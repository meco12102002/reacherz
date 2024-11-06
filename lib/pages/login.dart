import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reacher/pages/dashboard.dart';
import '../components/my_button.dart';
import '../components/text_field.dart';
import '../helpers/helper_functions.dart';

class LoginPage extends StatefulWidget {


  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility toggle
  bool _isPasswordVisible = false;

  // Login method
  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (context.mounted) {
        Navigator.pop(context); // Close the loading dialog
        // Navigate to the Dashboard page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()), // Replace with your Dashboard widget
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the loading dialog
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetching the current theme context
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface, // Use background color from color scheme
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding for the entire column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.book,
                size: 80,
                color: colorScheme.primary, // Use primary color from color scheme
              ),
              const SizedBox(height: 25),

              // App name
              Text(
                "Reacher: Your Reading Teacher",
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Email field with padding
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0), // Spacing between fields
                child: SizedBox(
                  width: double.infinity, // Ensures full-width
                  child: MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                  ),
                ),
              ),

              // Password field with padding
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0), // Spacing between fields
                child: SizedBox(
                  width: double.infinity, // Ensures full-width
                  child: MyTextField(
                    hintText: "Password",
                    obscureText: !_isPasswordVisible, // Use the toggle for visibility
                    controller: passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: colorScheme.onSurface,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),
              // Forgot password text
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot password?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface, // Ensures good visibility
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Login button
              MyButton(
                text: "Login",
                onTap: login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
