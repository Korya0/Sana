import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

sealed class HadithFavoritesState {
  const HadithFavoritesState();

  bool isFavorite(HadithModel hadith) {
    if (this is HadithFavoritesLoaded) {
      return (this as HadithFavoritesLoaded).favorites.any(
        (f) => f.hadithContent == hadith.hadithContent,
      );
    }
    return false;
  }
}

class HadithFavoritesInitial extends HadithFavoritesState {
  const HadithFavoritesInitial();
}

class HadithFavoritesLoaded extends HadithFavoritesState {
  const HadithFavoritesLoaded(this.favorites);
  final List<HadithModel> favorites;
}
