import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/hadith_repository.dart';

class SearchHadithUseCase {
  final HadithRepository _repository;

  SearchHadithUseCase(this._repository);

  Future<Either<Failure, List<HadithEntity>>> call(
    String query, {
    int page = 1,
  }) async {
    return await _repository.searchHadith(query, page: page);
  }
}
