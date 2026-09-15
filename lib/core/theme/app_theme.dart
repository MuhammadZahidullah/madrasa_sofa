import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1F9F68); // A nice green from the mockup
  static const Color secondaryAccent = Color(0xFF6B4EE6); // Purple from the mockup

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      surface: const Color(0xFFF8F9FA),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Clean light background
    cardColor: Colors.white,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E293B),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep dark navy
    cardColor: const Color(0xFF1E293B), // Slightly lighter cards
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
