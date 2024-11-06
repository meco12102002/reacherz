import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFE81B9), // Primary color for main elements
  scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Background color
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFE81B9), // Primary color
    onPrimary: Colors.white, // Text color on primary elements
    secondary: Color(0xFF45B6D4), // Button color
    onSecondary: Colors.white, // Text color on secondary elements
    surface: Colors.white, // Background for cards
    onSurface: Color(0xFF40475F), // Regular text color
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color(0xFF40475F), // Title text color
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
    backgroundColor: Color(0xFFFE81B9), // AppBar background color
    iconTheme: IconThemeData(color: Colors.white), // AppBar icon color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 4,
  ),
  cardTheme: CardTheme(
    color: Colors.white, // Card background color
    shadowColor: const Color(0xFF9698A6), // Card shadow color
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF7F7F7), // Input field background color
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: Color(0xFF40475F)), // Label color
    hintStyle: const TextStyle(color: Color(0xFF9698A6)), // Hint text color
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF9698A6), // Icon color
  ),
);

