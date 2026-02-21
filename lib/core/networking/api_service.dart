import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ApiService {
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class ApiServiceImpl implements ApiService {
  ApiServiceImpl(this._dio);
  final Dio _dio;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options:
          options ??
          Options(
            responseType: ResponseType.plain,
            headers: kIsWeb ? null : {'Cache-Control': 'no-cache'},
          ),
    );
  }
}
