import 'package:flutter/foundation.dart';

class Logger {
  static const _reset = '\x1B[0m';
  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _yellow = '\x1B[33m';
  static const _cyan = '\x1B[36m';

  static void log(String message) {
    if (kDebugMode) {
      print('$_green : $message$_reset');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('$_red ERROR: $message$_reset');
      if (error != null) {
        print('$_red Error: $error$_reset');
      }
      if (stackTrace != null) {
        print('$_yellow StackTrace: $stackTrace$_reset');
      }
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      print('$_cyan DEBUG: $message$_reset');
    }
  }

  void w(String s) {}
}
