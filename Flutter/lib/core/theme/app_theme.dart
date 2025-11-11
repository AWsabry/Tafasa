import 'package:flutter/material.dart';

class AppTheme {
  // App Colors
  static const Color primaryPurple = Color(0xFF6f3774);
  static const Color primaryOrange = Color(0xFFFF6B35);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      primary: primaryPurple,
      secondary: primaryOrange,
    ),
    scaffoldBackgroundColor: const Color(0xFFFDF7F2),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'FFKhallab',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'FFKhallab',
        fontSize: 16,
        color: Colors.black54,
      ),
      displayLarge: TextStyle(
        fontFamily: 'GraphicSchool',
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      displayMedium: TextStyle(
        fontFamily: 'GraphicSchool',
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    fontFamily: 'FFKhallab',
  );
}