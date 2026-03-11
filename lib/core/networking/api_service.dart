import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ApiService {
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
}

class ApiServiceImpl implements ApiService {
  ApiServiceImpl(this._dio);
  final Dio _dio;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options:
          options ??
          Options(
            responseType: ResponseType.json,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 20),
            headers: kIsWeb ? null : {'Cache-Control': 'no-cache'},
          ),
    );
  }
}
