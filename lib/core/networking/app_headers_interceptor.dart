import 'package:dio/dio.dart';

class AppHeadersInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Use a very common Android User-Agent
    options.headers['User-Agent'] =
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36';
    options.headers['Accept'] = '*/*';

    super.onRequest(options, handler);
  }
}
