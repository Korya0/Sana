import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class IHadithRepository {
  Future<ApiResult<List<HadithEntity>>> searchHadith(
    String query, {
    int page = 1,
  });
}
