import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyContentRepository {
  DailyContentRepository(this._prefs) {
    // Initial cache of favorites
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _hadithShuffledIndicesKey = 'hadith_shuffled_indices';
  static const String _sunnahShuffledIndicesKey = 'sunnah_shuffled_indices';
  static const String _hadithCurrentIndexKey = 'hadith_current_index';
  static const String _sunnahCurrentIndexKey = 'sunnah_current_index';
  static const String _hadithLastViewedDateKey = 'hadith_last_viewed_date';
  static const String _sunnahLastViewedDateKey = 'sunnah_last_viewed_date';
  static const String _hadithViewedTodayKey = 'hadith_viewed_today';
  static const String _sunnahViewedTodayKey = 'sunnah_viewed_today';
  static const String _favoritesKey = 'daily_content_favorites';
  static const String _asmaShuffledIndicesKey = 'asma_shuffled_indices';
  static const String _asmaCurrentIndexKey = 'asma_current_index';
  static const String _asmaLastViewedDateKey = 'asma_last_viewed_date';

  // Memory cache
  List<DailyContentModel> _cachedFavorites = [];

  // --- Helper Methods (Generic) ---

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

  Future<void> _advanceIndex(
    String indexKey,
    String shuffleKey,
    int totalCount,
  ) async {
    if (totalCount <= 0) return;
    final currentIndex = _prefs.getInt(indexKey) ?? 0;
    final nextIndex = (currentIndex + 1) % totalCount;
    if (nextIndex == 0) {
      final newShuffle = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(shuffleKey, json.encode(newShuffle));
    }
    await _prefs.setInt(indexKey, nextIndex);
  }

  // --- Hadith Methods ---

  Future<Either<Failure, List<int>>> getHadithShuffledIndices(int count) =>
      _getShuffledIndices(_hadithShuffledIndicesKey, count);

  int getHadithCurrentIndex() => _prefs.getInt(_hadithCurrentIndexKey) ?? 0;
  Future<void> saveHadithCurrentIndex(int index) =>
      _prefs.setInt(_hadithCurrentIndexKey, index);

  String? getHadithLastViewedDate() =>
      _prefs.getString(_hadithLastViewedDateKey);
  Future<void> saveHadithLastViewedDate(String date) =>
      _prefs.setString(_hadithLastViewedDateKey, date);

  bool wasHadithViewedToday() => _prefs.getBool(_hadithViewedTodayKey) ?? false;
  Future<void> markHadithAsViewedToday() =>
      _prefs.setBool(_hadithViewedTodayKey, true);
  Future<void> resetHadithViewedStatus() =>
      _prefs.setBool(_hadithViewedTodayKey, false);

  Future<void> advanceHadith(int totalCount) async {
    await _advanceIndex(
      _hadithCurrentIndexKey,
      _hadithShuffledIndicesKey,
      totalCount,
    );
    await resetHadithViewedStatus();
  }

  Future<Either<Failure, DailyContentModel>> getCurrentHadith(
    List<DailyContentModel> all,
  ) async {
    if (all.isEmpty)
      return const Left(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    final indicesResult = await getHadithShuffledIndices(all.length);
    return indicesResult.fold(Left.new, (indices) {
      final index = getHadithCurrentIndex();
      return Right(all[indices[index % indices.length]]);
    });
  }

  // --- Sunnah Methods ---

  Future<Either<Failure, List<int>>> getSunnahShuffledIndices(int count) =>
      _getShuffledIndices(_sunnahShuffledIndicesKey, count);

  int getSunnahCurrentIndex() => _prefs.getInt(_sunnahCurrentIndexKey) ?? 0;
  Future<void> saveSunnahCurrentIndex(int index) =>
      _prefs.setInt(_sunnahCurrentIndexKey, index);

  String? getSunnahLastViewedDate() =>
      _prefs.getString(_sunnahLastViewedDateKey);
  Future<void> saveSunnahLastViewedDate(String date) =>
      _prefs.setString(_sunnahLastViewedDateKey, date);

  bool wasSunnahViewedToday() => _prefs.getBool(_sunnahViewedTodayKey) ?? false;
  Future<void> markSunnahAsViewedToday() =>
      _prefs.setBool(_sunnahViewedTodayKey, true);
  Future<void> resetSunnahViewedStatus() =>
      _prefs.setBool(_sunnahViewedTodayKey, false);

  Future<void> advanceSunnah(int totalCount) async {
    await _advanceIndex(
      _sunnahCurrentIndexKey,
      _sunnahShuffledIndicesKey,
      totalCount,
    );
    await resetSunnahViewedStatus();
  }

  Future<Either<Failure, DailyContentModel>> getCurrentSunnah(
    List<DailyContentModel> all,
  ) async {
    if (all.isEmpty)
      return const Left(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    final indicesResult = await getSunnahShuffledIndices(all.length);
    return indicesResult.fold(Left.new, (indices) {
      final index = getSunnahCurrentIndex();
      return Right(all[indices[index % indices.length]]);
    });
  }

  // --- Asma Methods ---

  Future<Either<Failure, List<int>>> getAsmaShuffledIndices(int count) =>
      _getShuffledIndices(_asmaShuffledIndicesKey, count);

  int getAsmaCurrentIndex() => _prefs.getInt(_asmaCurrentIndexKey) ?? 0;
  String? getAsmaLastViewedDate() => _prefs.getString(_asmaLastViewedDateKey);
  Future<void> saveAsmaLastViewedDate(String date) =>
      _prefs.setString(_asmaLastViewedDateKey, date);

  Future<void> advanceAsma(int totalCount) =>
      _advanceIndex(_asmaCurrentIndexKey, _asmaShuffledIndicesKey, totalCount);

  Future<Either<Failure, AsmaulHusnaModel>> getCurrentAsma(
    List<AsmaulHusnaModel> all,
  ) async {
    if (all.isEmpty)
      return const Left(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    final indicesResult = await getAsmaShuffledIndices(all.length);
    return indicesResult.fold(Left.new, (indices) {
      final index = getAsmaCurrentIndex();
      return Right(all[indices[index % indices.length]]);
    });
  }

  // --- Favorites Management (Optimized) ---

  List<DailyContentModel> _loadFavoritesFromPrefs() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded
          .map((e) => DailyContentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  List<DailyContentModel> getFavorites() => _cachedFavorites;

  Future<bool> toggleFavorite(DailyContentModel item) async {
    final favorites = List<DailyContentModel>.from(_cachedFavorites);
    final index = favorites.indexWhere(
      (f) => f.content == item.content && f.header == item.header,
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
      (f) => f.content == item.content && f.header == item.header,
    );
  }

  Future<void> reshuffleAll(int hadithCount, int sunnahCount) async {
    await _prefs.remove(_hadithShuffledIndicesKey);
    await _prefs.remove(_sunnahShuffledIndicesKey);
    await saveHadithCurrentIndex(0);
    await saveSunnahCurrentIndex(0);
    await resetHadithViewedStatus();
    await resetSunnahViewedStatus();
  }
}
