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
    String url = "https://dorar.net/dorar_api.json";
    Map<String, dynamic>? queryParams = {
      'skey': query,
      'st': 'a', // 'a' corresponds to allWords search
      'page': page.toString(),
    };

    if (kIsWeb) {
      // استخدام الـ Serverless Function الخاصة بنا لتجنب الحظر و الـ CORS
      url = "/api/hadith-search";
    }

    final response = await _apiService.get(url, queryParameters: queryParams);

    // موقع الدرر يعيد البيانات أحياناً كنص JSONP أو JSON بداخل String
    // سنتأكد من تحويلها لـ Map
    dynamic data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = response.data;
    }

    return HadithModel.fromJsonList(data);
  }
}
