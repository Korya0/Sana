import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

part 'hadith_favorites_state.freezed.dart';

@freezed
class HadithFavoritesState with _$HadithFavoritesState {
  const HadithFavoritesState._();

  const factory HadithFavoritesState.initial() = HadithFavoritesInitial;
  const factory HadithFavoritesState.loaded(List<HadithEntity> favorites) =
      HadithFavoritesLoaded;

  bool isFavorite(HadithEntity hadith) {
    return maybeWhen(
      loaded: (favorites) =>
          favorites.any((f) => f.hadithContent == hadith.hadithContent),
      orElse: () => false,
    );
  }
}
