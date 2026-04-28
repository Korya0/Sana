import 'package:sana/core/networking/api_clients/dorar_api_client.dart';
import 'package:sana/features/hadith_search/constants/hadith_api_constants.dart';
import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

class HadithRemoteDataSource implements IHadithRemoteDataSource {
  HadithRemoteDataSource(this._apiClient);
  final DorarApiClient _apiClient;

  @override
  Future<List<HadithModel>> searchHadith(String query, {int page = 1}) async {
    final response = await _apiClient.searchHadith(
      query: query,
      searchType: HadithApiConstants.searchTypeAllWords,
      page: page.toString(),
    );

    return HadithModel.fromJsonList(response);
  }
}
