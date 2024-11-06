import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFFE81B9), // Primary color for main elements
  scaffoldBackgroundColor: const Color(0xFF1B1B1B), // Dark background color
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFE81B9), // Primary color
    onPrimary: Colors.white, // Text color on primary elements
    secondary: Color(0xFF45B6D4), // Button color
    onSecondary: Colors.black, // Text color on secondary elements
    surface: Color(0xFF2A2A2A), // Background for cards
    onSurface: Color(0xFFFFFFFF), // Regular text color for dark mode
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color(0xFFFFFFFF), // Title text color
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF9698A6), // Regular text color
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF9698A6), // Secondary text color
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: Color(0xFF9698A6), // Small text color
      fontSize: 12,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF45B6D4), // Button background color
    textTheme: ButtonTextTheme.primary, // Text color on button
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Rounded corners for buttons
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: const Color(0xFF45B6D4), // Text color on elevated buttons
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2A2A2A), // AppBar background color for dark mode
    iconTheme: IconThemeData(color: Colors.white), // AppBar icon color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 4,
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF2A2A2A), // Dark background color for cards
    shadowColor: const Color(0xFF40475F), // Card shadow color
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF3A3A3A), // Dark fill color for input fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: Color(0xFFFFFFFF)), // Label color
    hintStyle: const TextStyle(color: Color(0xFF9698A6)), // Hint text color
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF9698A6), // Icon color in dark mode
  ),
);
