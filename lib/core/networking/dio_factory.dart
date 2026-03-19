import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sana/core/networking/app_headers_interceptor.dart';
import 'package:sana/core/networking/cors_interceptor.dart';
import 'package:sana/core/networking/performance_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio();
      const timeout = Duration(seconds: 30);

      _dio!
        ..options.connectTimeout = timeout
        ..options.receiveTimeout = timeout
        ..options.sendTimeout = timeout
        ..options.headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

      _addDioInterceptor();
      _dio?.interceptors.add(AppHeadersInterceptor());
      _dio?.interceptors.add(PerformanceInterceptor());
      _dio?.interceptors.add(CorsInterceptor());
    }
    return _dio!;
  }

  static void _addDioInterceptor() {
    if (kDebugMode) {
      _dio?.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }
  }
}
