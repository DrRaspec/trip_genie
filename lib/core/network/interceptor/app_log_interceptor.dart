import 'dart:convert';

import 'package:ai_chat_bot/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isSensitive = _isSensitivePath(options.path);

    AppLogger.api('''
🚀 REQUEST
├── METHOD: ${options.method}
├── URL: ${options.uri}
├── HEADERS:
${_pretty(options.headers)}
├── QUERY:
${_pretty(options.queryParameters)}
└── BODY:
${isSensitive ? '<hidden>' : _pretty(options.data)}
''');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final isSensitive = _isSensitivePath(response.requestOptions.path);

    AppLogger.api('''
✅ RESPONSE
├── STATUS: ${response.statusCode}
├── URL: ${response.requestOptions.uri}
└── DATA:
${isSensitive ? '<hidden>' : _pretty(response.data)}
''');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isSensitive = _isSensitivePath(err.requestOptions.path);

    AppLogger.error('''
❌ ERROR
├── METHOD: ${err.requestOptions.method}
├── URL: ${err.requestOptions.uri}
├── MESSAGE: ${err.message}
├── STATUS: ${err.response?.statusCode}
└── RESPONSE:
${isSensitive ? '<hidden>' : _pretty(err.response?.data)}
''');

    handler.next(err);
  }

  bool _isSensitivePath(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }

  String _pretty(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
