import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract interface class IHadithFavoritesRepository {
  Future<void> saveFavorites(List<HadithEntity> favorites);
  Future<List<HadithEntity>> getFavorites();
}
