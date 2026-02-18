import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

abstract class HadithRemoteDataSource {
  Future<List<HadithModel>> searchHadith(String query, {int page = 1});
}

class HadithRemoteDataSourceImpl implements HadithRemoteDataSource {
  final ApiService _apiService;

  HadithRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<HadithModel>> searchHadith(String query, {int page = 1}) async {
    // الرابط الأساسي
    String url = "https://dorar.net/dorar_api.json";

    // المعاملات المطلوبة
    Map<String, dynamic> queryParams = {
      'skey': query,
      'st': 'a',
      'page': page.toString(),
      // إضافة مفتاح الحل للويب: JSONP callback
      if (kIsWeb) 'callback': 'extract_data_sana',
    };

    if (kIsWeb) {
      // استخدام بروكسي AllOrigins لسحب النص الخام وتجنب CORS
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      url =
          "https://api.allorigins.win/raw?url=${Uri.encodeComponent(uri.toString())}";
      // تصفير المعاملات لأنها دمجت في الرابط
      queryParams = {};
    }

    final response = await _apiService.get(url, queryParameters: queryParams);
    String responseBody = response.data.toString();

    // فك تغليف الـ JSONP (تحويل extract_data_sana(...) إلى JSON صافي)
    if (kIsWeb && responseBody.contains('extract_data_sana(')) {
      final start = responseBody.indexOf('(') + 1;
      final end = responseBody.lastIndexOf(')');
      if (start < end) {
        responseBody = responseBody.substring(start, end);
      }
    }

    try {
      final dynamic data = jsonDecode(responseBody);
      return HadithModel.fromJsonList(data);
    } catch (e) {
      debugPrint('Error decoding JSON: $e');
      return [];
    }
  }
}
