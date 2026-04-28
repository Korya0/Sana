import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

abstract class IHadithFavoritesRepository {
  List<HadithModel> getFavorites();
  Future<bool> toggleFavorite(HadithModel hadith);
  bool isFavorite(HadithModel hadith);
}
