import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceInterceptor extends Interceptor {
  final Map<RequestOptions, HttpMetric> _metrics = {};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final metric = FirebasePerformance.instance.newHttpMetric(
      options.uri.toString(),
      _convertMethod(options.method),
    );

    await metric.start();
    _metrics[options] = metric;

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final metric = _metrics.remove(response.requestOptions);
    if (metric != null) {
      metric
        ..httpResponseCode = response.statusCode
        ..responsePayloadSize = response.data?.toString().length
        ..responseContentType = response.headers.value('content-type');
      await metric.stop();
    }
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final metric = _metrics.remove(err.requestOptions);
    if (metric != null) {
      metric
        ..httpResponseCode = err.response?.statusCode
        ..responsePayloadSize = err.response?.data?.toString().length;
      await metric.stop();
    }
    return super.onError(err, handler);
  }

  HttpMethod _convertMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.Get;
      case 'POST':
        return HttpMethod.Post;
      case 'PUT':
        return HttpMethod.Put;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'PATCH':
        return HttpMethod.Patch;
      default:
        return HttpMethod.Get;
    }
  }
}
