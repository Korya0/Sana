import 'package:sana/core/networking/result.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class IHadithRepository {
  Future<Result<List<HadithEntity>>> searchHadith(
    String query, {
    required int page,
  });
}
