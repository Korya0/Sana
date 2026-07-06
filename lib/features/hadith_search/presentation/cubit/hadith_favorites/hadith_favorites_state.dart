import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

@immutable
sealed class HadithFavoritesState {
  const HadithFavoritesState();
}

class HadithFavoritesInitial extends HadithFavoritesState {
  const HadithFavoritesInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HadithFavoritesInitial;

  @override
  int get hashCode => 0;
}

class HadithFavoritesLoaded extends HadithFavoritesState {
  const HadithFavoritesLoaded(this.favorites);
  final List<HadithEntity> favorites;

  bool isFavorite(HadithEntity hadith) {
    return favorites.any((f) => f == hadith);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithFavoritesLoaded &&
        const ListEquality<HadithEntity>().equals(other.favorites, favorites);
  }

  @override
  int get hashCode => const ListEquality<HadithEntity>().hash(favorites);
}
