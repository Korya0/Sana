import 'package:dio/dio.dart';
import 'package:sana/core/networking/dio_factory.dart';

/// Interceptor to inject common headers into all API requests.
/// This keeps [DioFactory] clean and allows dynamic updates
/// (e.g., Auth tokens or Accept-Language) in the future.
class AppHeadersInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // Example: Inject dynamic language or token here later
    // options.headers['Accept-Language'] = AppLocale.currentLanguageCode;
    // options.headers['Authorization'] = 'Bearer $token';

    super.onRequest(options, handler);
  }
}
