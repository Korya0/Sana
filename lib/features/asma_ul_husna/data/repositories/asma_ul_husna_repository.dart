import 'dart:convert';

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
  Future<bool> toggleAsmaFavorite(AsmaulHusnaModel item);
  bool isAsmaFavorite(AsmaulHusnaModel? item);
  List<AsmaulHusnaModel> getAsmaFavorites();
}

class AsmaUlHusnaRepository implements IAsmaUlHusnaRepository {
  AsmaUlHusnaRepository(this._prefs) {
    _cachedAsmaFavorites = _loadAsmaFavoritesFromPrefs();
  }
  final SharedPreferences _prefs;
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
}
