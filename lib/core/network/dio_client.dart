import 'package:ai_chat_bot/core/constants/api_constant.dart';
import 'package:ai_chat_bot/core/network/interceptor/app_log_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  DioClient._();

  static Dio create({Future<void> Function()? onSessionExpired}) {
    final options = BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final dio = Dio(options);

    dio.interceptors.addAll([if (kDebugMode) AppLogInterceptor()]);

    return dio;
  }
}
