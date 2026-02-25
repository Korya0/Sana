import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAsmaUlHusnaRepository {
  Future<Either<Failure, List<AsmaulHusnaModel>>> getNames();
  Future<Either<Failure, AsmaulHusnaModel>> getNameOfTheDay();
  Future<Either<Failure, AsmaulHusnaModel>> getCurrentDailyAsma(
    List<AsmaulHusnaModel> all,
  );
  Future<void> advanceAsma(int totalCount);
  Future<bool> toggleAsmaFavorite(AsmaulHusnaModel item);
  bool isAsmaFavorite(AsmaulHusnaModel? item);
  List<AsmaulHusnaModel> getAsmaFavorites();
  int getAsmaCurrentIndex();
  String? getAsmaLastViewedDate();
  Future<void> saveAsmaLastViewedDate(String date);
}

class AsmaUlHusnaRepository implements IAsmaUlHusnaRepository {
  AsmaUlHusnaRepository(this._prefs) {
    _cachedAsmaFavorites = _loadAsmaFavoritesFromPrefs();
  }
  final SharedPreferences _prefs;

  static const String _asmaShuffledIndicesKey = 'asma_shuffled_indices';
  static const String _asmaCurrentIndexKey = 'asma_current_index';
  static const String _asmaLastViewedDateKey = 'asma_last_viewed_date';
  static const String _asmaFavoritesKey = 'asma_content_favorites';

  List<AsmaulHusnaModel> _cachedAsmaFavorites = [];

  @override
  Future<Either<Failure, List<AsmaulHusnaModel>>> getNames() async {
    try {
      final names = await AsmaUlHusnaLocalDataSource.getNames();
      if (names.isEmpty) {
        return const Left(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Right(names);
    } catch (e) {
      return Left(
        CacheFailure(
          message: AppStrings.cacheError,
          technicalMessage: 'File: ${AppAssetsJson.asmaUlHusna} - Error: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AsmaulHusnaModel>> getNameOfTheDay() async {
    final result = await getNames();
    return result.fold(
      Left.new,
      (names) {
        final now = DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        return Right(names[dayOfYear % names.length]);
      },
    );
  }

  @override
  Future<Either<Failure, AsmaulHusnaModel>> getCurrentDailyAsma(
    List<AsmaulHusnaModel> all,
  ) async {
    if (all.isEmpty) {
      return const Left(
        MissingDataFailure(message: AppStrings.missingDataError),
      );
    }

    final indicesResult = await _getShuffledIndices(
      _asmaShuffledIndicesKey,
      all.length,
    );
    return indicesResult.fold(Left.new, (indices) {
      final index = getAsmaCurrentIndex();
      return Right(all[indices[index % indices.length]]);
    });
  }

  @override
  Future<void> advanceAsma(int totalCount) async {
    if (totalCount <= 0) return;
    final currentIndex = getAsmaCurrentIndex();
    final nextIndex = (currentIndex + 1) % totalCount;
    if (nextIndex == 0) {
      final newShuffle = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _prefs.setString(_asmaShuffledIndicesKey, json.encode(newShuffle));
    }
    await _prefs.setInt(_asmaCurrentIndexKey, nextIndex);
  }

  @override
  int getAsmaCurrentIndex() => _prefs.getInt(_asmaCurrentIndexKey) ?? 0;

  @override
  String? getAsmaLastViewedDate() => _prefs.getString(_asmaLastViewedDateKey);

  @override
  Future<void> saveAsmaLastViewedDate(String date) =>
      _prefs.setString(_asmaLastViewedDateKey, date);

  @override
  Future<bool> toggleAsmaFavorite(AsmaulHusnaModel item) async {
    final favorites = List<AsmaulHusnaModel>.from(_cachedAsmaFavorites);
    final index = favorites.indexWhere((f) => f.id == item.id);

    bool isNowFavorite;
    if (index != -1) {
      favorites.removeAt(index);
      isNowFavorite = false;
    } else {
      favorites.add(item);
      isNowFavorite = true;
    }

    _cachedAsmaFavorites = favorites;
    await _prefs.setString(
      _asmaFavoritesKey,
      json.encode(favorites.map((e) => e.toJson()).toList()),
    );
    return isNowFavorite;
  }

  @override
  bool isAsmaFavorite(AsmaulHusnaModel? item) {
    if (item == null) return false;
    return _cachedAsmaFavorites.any((f) => f.id == item.id);
  }

  @override
  List<AsmaulHusnaModel> getAsmaFavorites() => _cachedAsmaFavorites;

  List<AsmaulHusnaModel> _loadAsmaFavoritesFromPrefs() {
    final stored = _prefs.getString(_asmaFavoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded
          .map((e) => AsmaulHusnaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
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
}
