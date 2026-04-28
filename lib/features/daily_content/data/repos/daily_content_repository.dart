import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/daily_content/constants/daily_content_keys.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

abstract class IDailyContentRepository {
  Future<ApiResult<T>> getDailyItem<T>({
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
  DailyContentRepoImpl(this._prefs) {
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final ILocalStorageService _prefs;

  static const String _favoritesKey = StorageKeys.dailyContentFavorites;
  List<DailyContentModel> _cachedFavorites = [];

  // --- Key Helpers ---
  String _shuffledKey(String category) => '${category}_shuffled_indices';
  String _indexKey(String category) => '${category}_current_index';
  String _dateKey(String category) => '${category}_last_viewed_date';
  String _viewedStatusKey(String category) => '${category}_viewed_today';

  // --- Generic Logic ---

  @override
  Future<ApiResult<T>> getDailyItem<T>({
    required String category,
    required List<T> all,
  }) async {
    if (all.isEmpty) {
      return const ApiResult.failure(
        Failure.missingData(message: AppStrings.missingDataError),
      );
    }

    final indicesResult = await _getShuffledIndices(category, all.length);
    return indicesResult.when(
      success: (indices) {
        final currentIndex = _prefs.getInt(_indexKey(category)) ?? 0;
        final realIndex = indices[currentIndex % indices.length];
        return ApiResult.success(all[realIndex]);
      },
      failure: ApiResult.failure,
    );
  }

  @override
  Future<void> advanceCategoryIfNewDay(
    String category,
    int totalCount,
    String todayDate,
  ) async {
    final lastDate = _prefs.getString(_dateKey(category));
    if (lastDate != todayDate) {
      await _advanceIndex(category, totalCount);
      await _prefs.setString(_dateKey(category), todayDate);
      await _prefs.setBoolean(
        key: _viewedStatusKey(category),
        booleanValue: false,
      );
    }
  }

  @override
  Future<void> markViewed(String category, String todayDate) async {
    await _prefs.setBoolean(
      key: _viewedStatusKey(category),
      booleanValue: true,
    );
    await _prefs.setString(_dateKey(category), todayDate);
  }

  @override
  bool wasViewedToday(String category) =>
      _prefs.getBoolean(_viewedStatusKey(category)) ?? false;

  @override
  String? getLastViewedDate(String category) =>
      _prefs.getString(_dateKey(category));

  @override
  int getCurrentIndex(String category) =>
      _prefs.getInt(_indexKey(category)) ?? 0;

  // --- Favorites Logic ---

  @override
  Future<bool> toggleFavorite(DailyContentModel item) async {
    final favorites = List<DailyContentModel>.from(_cachedFavorites);
    final index = favorites.indexWhere(
      (f) => f.content == item.content && f.category == item.category,
    );

    bool isNowFavorite;
    if (index != -1) {
      favorites.removeAt(index);
      isNowFavorite = false;
    } else {
      favorites.add(item);
      isNowFavorite = true;
    }

    _cachedFavorites = favorites;
    await _prefs.setString(
      _favoritesKey,
      json.encode(favorites.map((e) => e.toJson()).toList()),
    );
    return isNowFavorite;
  }

  @override
  bool isFavorite(DailyContentModel? item) {
    if (item == null) return false;
    return _cachedFavorites.any(
      (f) => f.content == item.content && f.category == item.category,
    );
  }

  @override
  List<DailyContentModel> getFavorites() => _cachedFavorites;

  // --- Internal Helpers ---

  Future<void> _advanceIndex(String category, int totalCount) async {
    if (totalCount <= 0) return;
    final indexKey = _indexKey(category);
    final currentIndex = _prefs.getInt(indexKey) ?? 0;
    final nextIndex = (currentIndex + 1) % totalCount;

    if (nextIndex == 0) {
      final shuffleKey = _shuffledKey(category);
      final newShuffle = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(shuffleKey, json.encode(newShuffle));
    }
    await _prefs.setInt(indexKey, nextIndex);
  }

  Future<ApiResult<List<int>>> _getShuffledIndices(
    String category,
    int totalCount,
  ) async {
    final key = _shuffledKey(category);
    try {
      final stored = _prefs.getString(key);
      if (stored != null) {
        final decoded = json.decode(stored) as List<dynamic>;
        if (decoded.length == totalCount) {
          return ApiResult.success(decoded.cast<int>());
        }
      }
      final shuffled = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(key, json.encode(shuffled));
      return ApiResult.success(shuffled);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'GetShuffledIndices Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  List<DailyContentModel> _loadFavoritesFromPrefs() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded.map((e) {
        final map = e as Map<String, dynamic>;
        final categoryName = map[DailyContentKeys.category] as String?;
        final category = categoryName == DailyContentType.sunnah.name
            ? DailyContentType.sunnah
            : DailyContentType.hadith;
        return DailyContentModel.fromJson(map, category);
      }).toList();
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('LoadFavorites Error', error: e, stackTrace: stack),
      );
      return [];
    }
  }
}
