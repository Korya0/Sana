import 'dart:async';
import 'dart:convert';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/i_hadith_favorites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithFavoritesRepository implements IHadithFavoritesRepository {
  HadithFavoritesRepository(this._prefs) {
    _cachedFavorites = _loadFavoritesFromPrefs();
  }
  final SharedPreferences _prefs;
  static const String _favoritesKey = PrefKeys.hadithFavorites;

  List<HadithEntity> _cachedFavorites = [];

  @override
  List<HadithEntity> getFavorites() => _cachedFavorites;

  List<HadithEntity> _loadFavoritesFromPrefs() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded
          .map((item) => HadithModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      unawaited(
        AppLogger.error(
          'LoadHadithFavorites Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return [];
    }
  }

  Future<void> _saveFavorites() async {
    final encoded = _cachedFavorites
        .map((f) => (f as HadithModel).toJson())
        .toList();
    await _prefs.setString(_favoritesKey, json.encode(encoded));
  }

  @override
  Future<bool> toggleFavorite(HadithEntity hadith) async {
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
  bool isFavorite(HadithEntity hadith) {
    return _cachedFavorites.any(
      (f) => f.hadithContent == hadith.hadithContent,
    );
  }
}
