import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/daily_content/data/constants/daily_content_keys.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';

class DailyContentRepository {
  DailyContentRepository(this._prefs) {
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final ISharedPref _prefs;

  static const String _favoritesKey = PrefKeys.dailyContentFavorites;
  List<DailyContentModel> _cachedFavorites = [];

  // --- Key Helpers ---
  String _shuffledKey(String category) => '${category}_shuffled_indices';
  String _indexKey(String category) => '${category}_current_index';
  String _dateKey(String category) => '${category}_last_viewed_date';
  String _viewedStatusKey(String category) => '${category}_viewed_today';

  // --- Generic Logic ---

  Future<Either<Failure, T>> getDailyItem<T>({
    required String category,
    required List<T> all,
  }) async {
    if (all.isEmpty) {
      return const Left(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    }

    final indicesResult = await _getShuffledIndices(category, all.length);
    return indicesResult.fold(
      Left.new,
      (indices) {
        final currentIndex = _prefs.getInt(_indexKey(category)) ?? 0;
        final realIndex = indices[currentIndex % indices.length];
        return Right(all[realIndex]);
      },
    );
  }

  Future<void> advanceCategoryIfNewDay(
    String category,
    int totalCount,
    String todayDate,
  ) async {
    final lastDate = _prefs.getString(_dateKey(category));
    if (lastDate != todayDate) {
      await _advanceIndex(category, totalCount);
      await _prefs.setString(_dateKey(category), todayDate);
      await _prefs.setBoolean(_viewedStatusKey(category), false);
    }
  }

  Future<void> markViewed(String category, String todayDate) async {
    await _prefs.setBoolean(_viewedStatusKey(category), true);
    await _prefs.setString(_dateKey(category), todayDate);
  }

  bool wasViewedToday(String category) =>
      _prefs.getBoolean(_viewedStatusKey(category)) ?? false;

  String? getLastViewedDate(String category) =>
      _prefs.getString(_dateKey(category));

  int getCurrentIndex(String category) =>
      _prefs.getInt(_indexKey(category)) ?? 0;

  // --- Favorites Logic ---

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

  bool isFavorite(DailyContentModel? item) {
    if (item == null) return false;
    return _cachedFavorites.any(
      (f) => f.content == item.content && f.category == item.category,
    );
  }

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

  Future<Either<Failure, List<int>>> _getShuffledIndices(
    String category,
    int totalCount,
  ) async {
    final key = _shuffledKey(category);
    try {
      final stored = _prefs.getString(key);
      if (stored != null) {
        final decoded = json.decode(stored) as List<dynamic>;
        if (decoded.length == totalCount) {
          return Right(decoded.cast<int>());
        }
      }
      final shuffled = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(key, json.encode(shuffled));
      return Right(shuffled);
    } catch (e, stack) {
      unawaited(
        AppLogger.error(
          'GetShuffledIndices Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Left(
        CacheFailure(
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
    } catch (e, stack) {
      unawaited(
        AppLogger.error('LoadFavorites Error', error: e, stackTrace: stack),
      );
      return [];
    }
  }
}
