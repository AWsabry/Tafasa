import 'package:flutter/material.dart';

class SnackbarManager {
  static DateTime? _lastShownTime;

  static void show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 2),
    Duration debounceDuration = const Duration(seconds: 2),
  }) {
    final now = DateTime.now();
    if (_lastShownTime != null &&
        now.difference(_lastShownTime!).inMilliseconds <
            debounceDuration.inMilliseconds) {
      return;
    }

    _lastShownTime = now;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
