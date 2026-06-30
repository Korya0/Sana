import 'dart:async';
import 'dart:convert';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/data/repos/i_hadith_favorites_repository.dart';

class HadithFavoritesRepoImpl implements IHadithFavoritesRepository {
  HadithFavoritesRepoImpl(this._prefs) {
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final ILocalStorageService _prefs;
  static const String _favoritesKey = StorageKeys.hadithFavorites;

  List<HadithModel> _cachedFavorites = [];

  @override
  List<HadithModel> getFavorites() => _cachedFavorites;

  List<HadithModel> _loadFavoritesFromPrefs() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded
          .map(
            (item) => HadithModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.warn(
          'LoadHadithFavorites Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return [];
    }
  }

  Future<void> _saveFavorites() async {
    final encoded = _cachedFavorites.map((f) => f.toJson()).toList();
    await _prefs.setString(_favoritesKey, json.encode(encoded));
  }

  @override
  Future<bool> toggleFavorite(HadithModel hadith) async {
    final index = _cachedFavorites.indexWhere(
      (f) => f.hadithContent == hadith.hadithContent,
    );

    bool isNowFavorite;
    if (index != -1) {
      _cachedFavorites.removeAt(index);
      isNowFavorite = false;
    } else {
      _cachedFavorites.add(hadith);
      isNowFavorite = true;
    }

    await _saveFavorites();
    return isNowFavorite;
  }

  @override
  bool isFavorite(HadithModel hadith) {
    return _cachedFavorites.any(
      (f) => f.hadithContent == hadith.hadithContent,
    );
  }
}
