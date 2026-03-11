import 'package:sana/core/networking/api_service.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/core/constants/api_endpoints.dart';
import 'package:sana/features/hadith_search/data/constants/hadith_api_constants.dart';

import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';

import 'package:flutter/foundation.dart';

class HadithRemoteDataSource implements IHadithRemoteDataSource {
  HadithRemoteDataSource(this._apiService);
  final ApiService _apiService;

  @override
  Future<List<HadithModel>> searchHadith(String query, {int page = 1}) async {
    final queryParams = <String, dynamic>{
      HadithApiConstants.queryParamSkey: query,
      HadithApiConstants.queryParamSt: HadithApiConstants.searchTypeAllWords,
      HadithApiConstants.queryParamPage: page.toString(),
    };

    var url = ApiEndpoints.dorarApiUrl;
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    if (kIsWeb) {
      // Use corsproxy.io for transparent proxying on Web
      url = '${ApiEndpoints.corsProxyUrl}?$uri';
    } else {
      url = uri.toString();
    }

    final response = await _apiService.get<dynamic>(
      url,
    );

    return HadithModel.fromJsonList(response.data as Map<String, dynamic>);
  }
}
