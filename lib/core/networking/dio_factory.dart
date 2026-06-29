import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sana/core/constants/constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio();

      _dio!
        ..options.connectTimeout = AppConstants.apiTimeout
        ..options.receiveTimeout = AppConstants.apiTimeout;

      _addDioInterceptors();
    }
    return _dio!;
  }

  static void _addDioInterceptors() {
    final dio = _dio!;

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }
  }

  static void reset() {
    _dio = null;
  }
}
