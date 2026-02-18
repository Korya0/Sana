import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class HadithRepository {
  Future<Either<Failure, List<HadithEntity>>> searchHadith(
    String query, {
    int page = 1,
  });
}
