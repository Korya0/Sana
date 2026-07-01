import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class IHadithFavoritesRepository {
  Future<void> saveFavorites(List<HadithEntity> favorites);
  Future<List<HadithEntity>> getFavorites();
}
