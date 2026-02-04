import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// رابط Google Form لإرسال البلاغات والاقتراحات
const String _googleFormUrl =
    'https://docs.google.com/forms/d/e/1FAIpQLSdPeDFkhomnOsz1B6A-SM9kXsHWi_bVQdP7tlVvR3ImOv3hKQ/formResponse';

/// Entry IDs للحقول في Google Form
const String _entryMessage = 'entry.682540113';
const String _entryErrorDetails = 'entry.329507211';
const String _entryIsSuggestion = 'entry.1758294523';
const String _entryType = 'entry.466516440';
const String _entryTimestamp = 'entry.948439681';

class ReportRepository {
  final Dio _dio;

  ReportRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<void> sendReport({
    required String message,
    String? errorDetails,
    bool isSuggestion = false,
  }) async {
    // تحقق من الاتصال بالإنترنت
    final hasInternet = await _checkInternet();
    if (!hasInternet) {
      throw Exception('لا يوجد اتصال بالإنترنت، حاول مرة أخرى لاحقاً.');
    }

    final timestamp = DateTime.now().toIso8601String();
    final type = errorDetails != null ? 'system' : 'user';

    // تعبئة الحقول المطلوبة بقيم افتراضية لتجنب رفض جوجل
    final safeErrorDetails = (errorDetails == null || errorDetails.isEmpty)
        ? 'لا يوجد'
        : errorDetails;

    final formData = {
      _entryMessage: message,
      _entryErrorDetails: safeErrorDetails,
      _entryIsSuggestion: isSuggestion.toString(),
      _entryType: type,
      _entryTimestamp: timestamp,

      // Hidden fields required by Google Forms
      'fvv': '1',
      'pageHistory': '0',
      'fbzx': '4395424811796860332',
    };

    // Manual URL encoding to ensure Google Forms accepts it
    final data = formData.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    try {
      final response = await _dio.post(
        _googleFormUrl,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain, // Accept text response
          validateStatus: (status) {
            // [Web Support] في الويب، قد يعود status بـ 0 بسبب CORS رغم وصول البيانات
            if (kIsWeb) {
              return true; // On web, CORS may cause status to be 0 or null but data still sent
            }
            return status == 200;
          },
          headers: kIsWeb
              ? null
              : {
                  // [Web Support] إرسال Content-Length يدوي ممنوع في المتصفحات
                  'Content-Length': data.length.toString(), // Explicit length
                },
        ),
      );

      if (kDebugMode) {
        print('Google Form Response Status: ${response.statusCode}');
        // Print first 500 chars to avoid clutter, enough to see success title
        print(
          'Google Form Response Body: ${response.data.toString().substring(0, 500)}',
        );
      }
    } catch (e) {
      if (kIsWeb) {
        // [Web Support] في الويب، جوجل تمنع قراءة الرد (CORS Error) ولكن البيانات تصل فعلياً
        // لذا نعتبر العملية نجحت لتجنب إظهار رسالة خطأ للمستخدم
        if (kDebugMode) {
          print('Web CORS error ignored as the message was likely sent: $e');
        }
        return; // Treat as success
      }

      if (kDebugMode) {
        print('Error sending report: $e');
      }
      throw Exception('فشل إرسال البلاغ: $e');
    }
  }

  Future<bool> _checkInternet() async {
    // [Web Support] المتصفح لا يسمح بعمل Ping لمواقع خارجية (CORS) لذا نتجاوز الفحص
    if (kIsWeb) {
      return true; // Browser handles connection status, and CORS prevents pinging google.com
    }
    try {
      final response = await _dio.get(
        'https://google.com',
        options: Options(receiveTimeout: const Duration(seconds: 3)),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
