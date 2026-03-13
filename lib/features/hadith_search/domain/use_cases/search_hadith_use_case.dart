import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/i_hadith_repository.dart';

class SearchHadithUseCase {
  SearchHadithUseCase(this._repository);
  final IHadithRepository _repository;

  Future<ApiResult<List<HadithEntity>>> call(
    String query, {
    int page = 1,
  }) async {
    return _repository.searchHadith(query, page: page);
  }
}
