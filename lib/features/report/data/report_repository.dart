import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class ReportRepository {
  final FirebaseFirestore _firestore;
  final Dio _dio;

  ReportRepository({FirebaseFirestore? firestore, Dio? dio})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _dio = dio ?? Dio();

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

    final reportData = {
      'message': message,
      'errorDetails': errorDetails,
      'isSuggestion': isSuggestion,
      'type': errorDetails != null ? 'system' : 'user',
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('reports').add(reportData);
    } catch (e) {
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
