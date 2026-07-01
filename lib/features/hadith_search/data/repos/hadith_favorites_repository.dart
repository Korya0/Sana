import 'dart:async';
import 'dart:convert';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repos/i_hadith_favorites_repository.dart';

class HadithFavoritesRepoImpl implements IHadithFavoritesRepository {
  HadithFavoritesRepoImpl(this._prefs) {
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final ILocalStorageService _prefs;
  static const String _favoritesKey = StorageKeys.hadithFavorites;

  List<HadithEntity> _cachedFavorites = [];

  @override
  Future<List<HadithEntity>> getFavorites() async => _cachedFavorites;

  List<HadithEntity> _loadFavoritesFromPrefs() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded
          .map(
            (item) => HadithModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'LoadHadithFavorites Error',
          error: e,
          stackTrace: stack,
          report: true,
        ),
      );
      return [];
    }
  }

  Future<void> _saveFavorites() async {
    final encoded = _cachedFavorites.map((f) {
      // Cast to HadithModel to use toJson, or map it manually
      return HadithModel(
        hadithContent: f.hadithContent,
        narrator: f.narrator,
        scholar: f.scholar,
        source: f.source,
        page: f.page,
        judgment: f.judgment,
        judgmentType: f.judgmentType,
        displayContent: f.displayContent,
      ).toJson();
    }).toList();
    await _prefs.setString(_favoritesKey, json.encode(encoded));
  }

  @override
  Future<void> saveFavorites(List<HadithEntity> favorites) async {
    _cachedFavorites = List.from(favorites);
    await _saveFavorites();
  }
}
