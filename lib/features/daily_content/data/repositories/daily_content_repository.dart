import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyContentRepository {
  DailyContentRepository(this._prefs) {
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final SharedPreferences _prefs;

  static const String _hadithShuffledIndicesKey = 'hadith_shuffled_indices';
  static const String _hadithCurrentIndexKey = 'hadith_current_index';
  static const String _sunnahShuffledIndicesKey = 'sunnah_shuffled_indices';
  static const String _sunnahCurrentIndexKey = 'sunnah_current_index';

  static const String _hadithLastViewedDateKey = 'hadith_last_viewed_date';
  static const String _sunnahLastViewedDateKey = 'sunnah_last_viewed_date';

  static const String _hadithViewedTodayKey = 'hadith_viewed_today';
  static const String _sunnahViewedTodayKey = 'sunnah_viewed_today';

  static const String _favoritesKey = 'daily_content_favorites';

  List<DailyContentModel> _cachedFavorites = [];

  // --- Hadith Logic ---

  Future<Either<Failure, DailyContentModel>> getCurrentHadith(
    List<DailyContentModel> all,
  ) async {
    return _getCurrentItem(
      all,
      _hadithShuffledIndicesKey,
      _hadithCurrentIndexKey,
    );
  }

  Future<void> advanceHadith(int totalCount) async {
    await _advanceIndex(
      _hadithCurrentIndexKey,
      _hadithShuffledIndicesKey,
      totalCount,
    );
    await resetHadithViewedStatus();
  }

  int getHadithCurrentIndex() => _prefs.getInt(_hadithCurrentIndexKey) ?? 0;

  String? getHadithLastViewedDate() =>
      _prefs.getString(_hadithLastViewedDateKey);

  Future<void> saveHadithLastViewedDate(String date) =>
      _prefs.setString(_hadithLastViewedDateKey, date);

  bool wasHadithViewedToday() => _prefs.getBool(_hadithViewedTodayKey) ?? false;

  Future<void> markHadithAsViewedToday() =>
      _prefs.setBool(_hadithViewedTodayKey, true);

  Future<void> resetHadithViewedStatus() =>
      _prefs.setBool(_hadithViewedTodayKey, false);

  // --- Sunnah Logic ---

  Future<Either<Failure, DailyContentModel>> getCurrentSunnah(
    List<DailyContentModel> all,
  ) async {
    return _getCurrentItem(
      all,
      _sunnahShuffledIndicesKey,
      _sunnahCurrentIndexKey,
    );
  }

  Future<void> advanceSunnah(int totalCount) async {
    await _advanceIndex(
      _sunnahCurrentIndexKey,
      _sunnahShuffledIndicesKey,
      totalCount,
    );
    await resetSunnahViewedStatus();
  }

  int getSunnahCurrentIndex() => _prefs.getInt(_sunnahCurrentIndexKey) ?? 0;

  String? getSunnahLastViewedDate() =>
      _prefs.getString(_sunnahLastViewedDateKey);

  Future<void> saveSunnahLastViewedDate(String date) =>
      _prefs.setString(_sunnahLastViewedDateKey, date);

  bool wasSunnahViewedToday() => _prefs.getBool(_sunnahViewedTodayKey) ?? false;

  Future<void> markSunnahAsViewedToday() =>
      _prefs.setBool(_sunnahViewedTodayKey, true);

  Future<void> resetSunnahViewedStatus() =>
      _prefs.setBool(_sunnahViewedTodayKey, false);

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

  // --- General Helpers ---

  Future<Either<Failure, DailyContentModel>> _getCurrentItem(
    List<DailyContentModel> all,
    String shuffleKey,
    String indexKey,
  ) async {
    if (all.isEmpty) {
      return const Left(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    }

    final indicesResult = await _getShuffledIndices(shuffleKey, all.length);

    return indicesResult.fold(
      Left.new,
      (indices) {
        final currentIndex = _prefs.getInt(indexKey) ?? 0;
        final realIndex = indices[currentIndex % indices.length];
        return Right(all[realIndex]);
      },
    );
  }

  Future<void> _advanceIndex(
    String indexKey,
    String shuffleKey,
    int totalCount,
  ) async {
    if (totalCount <= 0) return;

    final currentIndex = _prefs.getInt(indexKey) ?? 0;
    final nextIndex = (currentIndex + 1) % totalCount;

    // If we've gone through the whole list, reshuffle
    if (nextIndex == 0) {
      final newShuffle = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(shuffleKey, json.encode(newShuffle));
    }

    await _prefs.setInt(indexKey, nextIndex);
  }

  Future<Either<Failure, List<int>>> _getShuffledIndices(
    String key,
    int totalCount,
  ) async {
    try {
      final stored = _prefs.getString(key);
      if (stored != null) {
        final decoded = json.decode(stored) as List<dynamic>;
        if (decoded.length == totalCount) {
          return Right(decoded.cast<int>());
        }
      }

      // Generate new shuffle if not found or size mismatch
      final shuffled = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(key, json.encode(shuffled));
      return Right(shuffled);
    } catch (e) {
      return Left(
        CacheFailure(
          message: AppStrings.cacheError,
          technicalMessage: e.toString(),
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
        final categoryName = map['category'] as String?;
        final category = categoryName == DailyContentType.sunnah.name
            ? DailyContentType.sunnah
            : DailyContentType.hadith;
        return DailyContentModel.fromJson(map, category);
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
