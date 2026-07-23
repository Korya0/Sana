import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/daily_content/data/datasources/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/services/daily_content_favorites_service.dart';
import 'package:sana/features/daily_content/data/services/daily_content_shuffle_service.dart';

abstract interface class IDailyContentRepository {
  Future<Map<String, List<DailyContentModel>>> loadDailyContent();
  Future<Result<T>> getDailyItem<T>({
    required String category,
    required List<T> all,
  });

  Future<void> advanceCategoryIfNewDay(
    String category,
    int totalCount,
    String todayDate,
  );

  Future<void> markViewed(String category, String todayDate);
  bool wasViewedToday(String category);
  String? getLastViewedDate(String category);
  int getCurrentIndex(String category);

  Future<bool> toggleFavorite(DailyContentModel item);
  bool isFavorite(DailyContentModel? item);
  List<DailyContentModel> getFavorites();
}

class DailyContentRepoImpl implements IDailyContentRepository {
  DailyContentRepoImpl(
    this._dataSource,
    this._shuffleService,
    this._favoritesService,
  );

  final IDailyContentDataSource _dataSource;
  final DailyContentShuffleService _shuffleService;
  final DailyContentFavoritesService _favoritesService;

  @override
  Future<Map<String, List<DailyContentModel>>> loadDailyContent() =>
      _dataSource.loadDailyContent();

  // --- Daily Item Logic ---

  @override
  Future<Result<T>> getDailyItem<T>({
    required String category,
    required List<T> all,
  }) async {
    if (all.isEmpty) {
      return const Result.failure(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    }

    final indicesResult =
        await _shuffleService.getShuffledIndices(category, all.length);
    return switch (indicesResult) {
      Success(data: final indices) => () {
        final currentIndex = _shuffleService.getCurrentIndex(category);
        final realIndex = indices[currentIndex % indices.length];
        return Result.success(all[realIndex]);
      }(),
      FailureResult(failure: final f) => Result.failure(f),
    };
  }

  @override
  Future<void> advanceCategoryIfNewDay(
    String category,
    int totalCount,
    String todayDate,
  ) async {
    final lastDate = _shuffleService.getLastViewedDate(category);
    if (lastDate == null) {
      await _shuffleService.resetForNewDay(category, todayDate);
    } else if (lastDate != todayDate) {
      await _shuffleService.advanceIndex(category, totalCount);
      await _shuffleService.resetForNewDay(category, todayDate);
    }
  }

  @override
  Future<void> markViewed(String category, String todayDate) async {
    await _shuffleService.markViewed(category, todayDate);
  }

  @override
  bool wasViewedToday(String category) =>
      _shuffleService.wasViewedToday(category);

  @override
  String? getLastViewedDate(String category) =>
      _shuffleService.getLastViewedDate(category);

  @override
  int getCurrentIndex(String category) =>
      _shuffleService.getCurrentIndex(category);

  // --- Favorites Delegation ---

  @override
  Future<bool> toggleFavorite(DailyContentModel item) =>
      _favoritesService.toggle(item);

  @override
  bool isFavorite(DailyContentModel? item) =>
      _favoritesService.isFavorite(item);

  @override
  List<DailyContentModel> getFavorites() => _favoritesService.getAll();
}
