import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repos/i_hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart';

class HadithFavoritesCubit extends Cubit<HadithFavoritesState> {
  HadithFavoritesCubit(this._repository)
    : super(const HadithFavoritesInitial());

  final IHadithFavoritesRepository _repository;

  Future<void> loadFavorites() async {
    final favorites = await _repository.getFavorites();
    if (isClosed) return;
    emit(HadithFavoritesLoaded(List.from(favorites)));
  }

  void toggleFavorite(HadithEntity hadith) {
    if (state is HadithFavoritesLoaded) {
      final currentState = state as HadithFavoritesLoaded;
      final currentList = List<HadithEntity>.from(currentState.favorites);
      final originalList = List<HadithEntity>.from(currentState.favorites);

      final isFav = currentList.any((f) => f == hadith);
      if (isFav) {
        currentList.removeWhere((f) => f == hadith);
      } else {
        currentList.add(hadith);
      }

      // Optimistic update
      emit(HadithFavoritesLoaded(currentList));

      // Background save
      unawaited(_saveWithRollback(currentList, originalList));
    }
  }

  Future<void> _saveWithRollback(
    List<HadithEntity> newList,
    List<HadithEntity> originalList,
  ) async {
    try {
      await _repository.saveFavorites(newList);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error('Failed to save favorite', error: e, stackTrace: stack),
      );
      if (!isClosed) {
        // Rollback
        emit(HadithFavoritesLoaded(originalList));
      }
    }
  }
}
