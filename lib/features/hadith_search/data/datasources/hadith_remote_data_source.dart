import 'dart:convert';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/core/constants/api_constants.dart';

import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';

import 'package:flutter/foundation.dart';

class HadithRemoteDataSource implements IHadithRemoteDataSource {
  HadithRemoteDataSource(this._apiService);
  final ApiService _apiService;

  @override
  Future<List<HadithModel>> searchHadith(String query, {int page = 1}) async {
    final queryParams = <String, dynamic>{
      ApiConstants.queryParamSkey: query,
      ApiConstants.queryParamSt: ApiConstants.searchTypeAllWords,
      ApiConstants.queryParamPage: page.toString(),
    };

    var url = ApiConstants.dorarApiUrl;
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    if (kIsWeb) {
      // Use corsproxy.io for transparent proxying on Web
      url = '${ApiConstants.corsProxyUrl}?$uri';
    } else {
      url = uri.toString();
    }

    final response = await _apiService.get<dynamic>(
      url,
    );

    final dynamic data = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;

    return HadithModel.fromJsonList(data as Map<String, dynamic>);
  }
}
