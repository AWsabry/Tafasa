import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
    scaffoldBackgroundColor: const Color(0xFFFDF7F2),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
    ),
  );
}