import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/hadith_repository.dart';

class SearchHadithUseCase {
  SearchHadithUseCase(this._repository);
  final HadithRepository _repository;

  Future<Either<Failure, List<HadithEntity>>> call(
    String query, {
    int page = 1,
  }) async {
    return _repository.searchHadith(query, page: page);
  }
}
