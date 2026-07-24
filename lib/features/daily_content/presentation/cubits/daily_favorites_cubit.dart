import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/cubits/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubits/daily_favorites_state.dart';

class DailyFavoritesCubit extends Cubit<DailyFavoritesState> {
  DailyFavoritesCubit(this.repository, this.dailyContentCubit)
    : super(const DailyFavoritesState()) {
    loadFavorites();
  }

  final DailyContentRepository repository;
  final DailyContentCubit dailyContentCubit;

  void loadFavorites() {
    emit(DailyFavoritesState(favorites: repository.getFavorites()));
  }

  Future<void> toggleFavorite(DailyContentModel item) async {
    await repository.toggleFavorite(item);
    // Sync the main cubit state so cards in home update immediately
    dailyContentCubit.syncFavoritesState();
    loadFavorites();
  }
}
