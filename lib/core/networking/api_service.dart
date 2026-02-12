import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ApiService {
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class ApiServiceImpl implements ApiService {
  final Dio _dio;

  ApiServiceImpl(this._dio);

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              responseType: ResponseType.plain,
              headers: kIsWeb ? null : {'Cache-Control': 'no-cache'},
            ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
