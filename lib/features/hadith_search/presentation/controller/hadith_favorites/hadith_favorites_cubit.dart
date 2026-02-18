import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/data/repositories/hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_state.dart';

class HadithFavoritesCubit extends Cubit<HadithFavoritesState> {
  final HadithFavoritesRepository _repository;

  HadithFavoritesCubit(this._repository) : super(HadithFavoritesInitial());

  void loadFavorites() {
    final favorites = _repository.getFavorites();
    emit(HadithFavoritesLoaded(favorites));
  }

  Future<void> toggleFavorite(HadithEntity hadith) async {
    await _repository.toggleFavorite(hadith);
    loadFavorites();
  }

  bool isFavorite(HadithEntity hadith) {
    return _repository.isFavorite(hadith);
  }
}
