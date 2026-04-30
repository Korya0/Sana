import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

abstract class IHadithRepository {
  Future<ApiResult<List<HadithModel>>> searchHadith(
    String query, {
    int page = 1,
  });
}
