import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/data/repos/i_hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart';

class HadithFavoritesCubit extends Cubit<HadithFavoritesState> {
  HadithFavoritesCubit(this._repository)
    : super(const HadithFavoritesInitial()) {
    loadFavorites();
  }
  final IHadithFavoritesRepository _repository;

  void loadFavorites() {
    final favorites = _repository.getFavorites();
    emit(HadithFavoritesLoaded(List.from(favorites)));
  }

  void toggleFavorite(HadithModel hadith) {
    if (state is HadithFavoritesLoaded) {
      final currentState = state as HadithFavoritesLoaded;
      final currentList = List<HadithModel>.from(currentState.favorites);

      final isFav = currentList.any(
        (f) => f.hadithContent == hadith.hadithContent,
      );
      if (isFav) {
        currentList.removeWhere((f) => f.hadithContent == hadith.hadithContent);
      } else {
        currentList.add(hadith);
      }

      emit(HadithFavoritesLoaded(currentList));
      unawaited(_repository.toggleFavorite(hadith));
    }
  }
}
