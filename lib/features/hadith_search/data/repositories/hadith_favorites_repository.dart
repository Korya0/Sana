import 'dart:convert';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithFavoritesRepository {
  HadithFavoritesRepository(this._prefs);
  final SharedPreferences _prefs;
  static const String _favoritesKey = PrefKeys.hadithFavorites;

  List<HadithEntity> getFavorites() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    final decoded = json.decode(stored) as List<dynamic>;
    return decoded
        .map((item) => HadithModel(hadithContent: item as String))
        .toList();
  }

  Future<void> _saveFavorites(List<HadithEntity> favorites) async {
    final encoded = favorites.map((f) => f.hadithContent).toList();
    await _prefs.setString(_favoritesKey, json.encode(encoded));
  }

  Future<bool> toggleFavorite(HadithEntity hadith) async {
    final favorites = getFavorites();
    final index = favorites.indexWhere(
      (f) => f.hadithContent == hadith.hadithContent,
    );

    if (index != -1) {
      favorites.removeAt(index);
      await _saveFavorites(favorites);
      return false; // Result: not favorite
    } else {
      favorites.add(hadith);
      await _saveFavorites(favorites);
      return true; // Result: favorite
    }
  }

  bool isFavorite(HadithEntity hadith) {
    final favorites = getFavorites();
    return favorites.any((f) => f.hadithContent == hadith.hadithContent);
  }
}
