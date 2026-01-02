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

    final formData = {
      _entryMessage: message,
      _entryErrorDetails: errorDetails ?? '',
      _entryIsSuggestion: isSuggestion.toString(),
      _entryType: type,
      _entryTimestamp: timestamp,
    };

    try {
      await _dio.post(
        _googleFormUrl,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          // Google Forms returns 200 even on success, but we don't need the response
          validateStatus: (status) => status != null && status < 500,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending report: $e');
      }
      throw Exception('فشل إرسال البلاغ: $e');
    }
  }

  Future<bool> _checkInternet() async {
    try {
      final response = await _dio.get(
        'https://google.com',
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
