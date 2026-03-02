import 'dart:convert';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/core/constants/api_constants.dart';

abstract class HadithRemoteDataSource {
  Future<List<HadithModel>> searchHadith(String query, {int page = 1});
}

class HadithRemoteDataSourceImpl implements HadithRemoteDataSource {
  HadithRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;

  @override
  Future<List<HadithModel>> searchHadith(String query, {int page = 1}) async {
    final queryParams = <String, dynamic>{
      ApiConstants.queryParamSkey: query,
      ApiConstants.queryParamSt: ApiConstants.searchTypeAllWords,
      ApiConstants.queryParamPage: page.toString(),
    };

    final response = await _apiService.get<dynamic>(
      ApiConstants.dorarApiUrl,
      queryParameters: queryParams,
    );

    // موقع الدرر يعيد البيانات أحياناً كنص JSONP أو JSON بداخل String
    // سنتأكد من تحويلها لـ Map
    dynamic data;
    if (response.data is String) {
      data = jsonDecode(response.data as String);
    } else {
      data = response.data;
    }

    return HadithModel.fromJsonList(data as Map<String, dynamic>);
  }
}
