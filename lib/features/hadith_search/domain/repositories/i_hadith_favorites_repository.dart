import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class IHadithFavoritesRepository {
  List<HadithEntity> getFavorites();
  Future<bool> toggleFavorite(HadithEntity hadith);
  bool isFavorite(HadithEntity hadith);
}
