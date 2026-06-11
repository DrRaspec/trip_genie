import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static const String _appTag = 'VTSChat';

  static void info(String message, {Object? data}) {
    _log('INFO', message, data: data);
  }

  static void warning(String message, {Object? data}) {
    _log('WARNING', message, data: data);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    if (!kDebugMode) return;

    debugPrint('[$_appTag][ERROR] $message');

    if (data != null) {
      debugPrint('[$_appTag][ERROR][DATA] ${_maskSensitiveData(data)}');
    }

    if (error != null) {
      debugPrint('[$_appTag][ERROR][DETAIL] $error');
    }

    if (stackTrace != null) {
      debugPrint('[$_appTag][STACKTRACE] $stackTrace');
    }
  }

  static void api(String message, {Object? data}) {
    _log('API', message, data: data);
  }

  static void _log(String level, String message, {Object? data}) {
    if (!kDebugMode) return;

    debugPrint('[$_appTag][$level] $message');

    if (data != null) {
      debugPrint('[$_appTag][$level][DATA] ${_maskSensitiveData(data)}');
    }
  }

  static dynamic _maskSensitiveData(dynamic value) {
    if (value is Map) {
      return value.map((key, item) {
        final keyString = key.toString().toLowerCase();

        final isSensitive =
            keyString.contains('password') ||
            keyString.contains('token') ||
            keyString.contains('authorization') ||
            keyString.contains('secret') ||
            keyString.contains('otp');

        if (isSensitive) {
          return MapEntry(key, '***');
        }

        return MapEntry(key, _maskSensitiveData(item));
      });
    }

    if (value is List) {
      return value.map(_maskSensitiveData).toList();
    }

    return value;
  }
}
