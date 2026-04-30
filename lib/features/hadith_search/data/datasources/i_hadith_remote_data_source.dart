import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

abstract class IHadithRemoteDataSource {
  Future<List<HadithModel>> searchHadith(String query, {int page = 1});
}
