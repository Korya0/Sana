import 'dart:convert';
import 'dart:math';

import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyContentRepository {
  DailyContentRepository(this._prefs);
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

  /// Get shuffled indices for hadiths, creating new shuffle if needed
  Future<List<int>> getHadithShuffledIndices(int totalCount) async {
    final stored = _prefs.getString(_hadithShuffledIndicesKey);
    if (stored != null) {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded.cast<int>();
    }

    // Create new shuffled list
    final shuffled = _generateShuffledIndices(totalCount);
    await _saveHadithShuffledIndices(shuffled);
    return shuffled;
  }

  /// Get shuffled indices for sunnah, creating new shuffle if needed
  Future<List<int>> getSunnahShuffledIndices(int totalCount) async {
    final stored = _prefs.getString(_sunnahShuffledIndicesKey);
    if (stored != null) {
      final decoded = json.decode(stored) as List<dynamic>;
      return decoded.cast<int>();
    }

    // Create new shuffled list
    final shuffled = _generateShuffledIndices(totalCount);
    await _saveSunnahShuffledIndices(shuffled);
    return shuffled;
  }

  /// Generate shuffled indices from 0 to count-1
  List<int> _generateShuffledIndices(int count) {
    final indices = List<int>.generate(count, (index) => index)
      ..shuffle(Random());
    return indices;
  }

  /// Save hadith shuffled indices
  Future<void> _saveHadithShuffledIndices(List<int> indices) async {
    await _prefs.setString(_hadithShuffledIndicesKey, json.encode(indices));
  }

  /// Save sunnah shuffled indices
  Future<void> _saveSunnahShuffledIndices(List<int> indices) async {
    await _prefs.setString(_sunnahShuffledIndicesKey, json.encode(indices));
  }

  /// Get current hadith index
  int getHadithCurrentIndex() {
    return _prefs.getInt(_hadithCurrentIndexKey) ?? 0;
  }

  /// Get current sunnah index
  int getSunnahCurrentIndex() {
    return _prefs.getInt(_sunnahCurrentIndexKey) ?? 0;
  }

  /// Save hadith current index
  Future<void> saveHadithCurrentIndex(int index) async {
    await _prefs.setInt(_hadithCurrentIndexKey, index);
  }

  /// Save sunnah current index
  Future<void> saveSunnahCurrentIndex(int index) async {
    await _prefs.setInt(_sunnahCurrentIndexKey, index);
  }

  /// Get last viewed date for hadith (returns date string or null)
  String? getHadithLastViewedDate() {
    return _prefs.getString(_hadithLastViewedDateKey);
  }

  /// Get last viewed date for sunnah (returns date string or null)
  String? getSunnahLastViewedDate() {
    return _prefs.getString(_sunnahLastViewedDateKey);
  }

  /// Save hadith last viewed date
  Future<void> saveHadithLastViewedDate(String date) async {
    await _prefs.setString(_hadithLastViewedDateKey, date);
  }

  /// Save sunnah last viewed date
  Future<void> saveSunnahLastViewedDate(String date) async {
    await _prefs.setString(_sunnahLastViewedDateKey, date);
  }

  /// Check if hadith was viewed today
  bool wasHadithViewedToday() {
    return _prefs.getBool(_hadithViewedTodayKey) ?? false;
  }

  /// Check if sunnah was viewed today
  bool wasSunnahViewedToday() {
    return _prefs.getBool(_sunnahViewedTodayKey) ?? false;
  }

  /// Mark hadith as viewed today
  Future<void> markHadithAsViewedToday() async {
    await _prefs.setBool(_hadithViewedTodayKey, true);
  }

  /// Mark sunnah as viewed today
  Future<void> markSunnahAsViewedToday() async {
    await _prefs.setBool(_sunnahViewedTodayKey, true);
  }

  /// Reset hadith viewed status (called when day changes)
  Future<void> resetHadithViewedStatus() async {
    await _prefs.setBool(_hadithViewedTodayKey, false);
  }

  /// Reset sunnah viewed status (called when day changes)
  Future<void> resetSunnahViewedStatus() async {
    await _prefs.setBool(_sunnahViewedTodayKey, false);
  }

  /// Reset all shuffled indices (create new shuffle)
  Future<void> reshuffleAll(int hadithCount, int sunnahCount) async {
    final newHadithShuffle = _generateShuffledIndices(hadithCount);
    final newSunnahShuffle = _generateShuffledIndices(sunnahCount);

    await _saveHadithShuffledIndices(newHadithShuffle);
    await _saveSunnahShuffledIndices(newSunnahShuffle);
    await saveHadithCurrentIndex(0);
    await saveSunnahCurrentIndex(0);
    await resetHadithViewedStatus();
    await resetSunnahViewedStatus();
  }

  /// Advance to next hadith (called when user views it and day ends)
  Future<void> advanceHadith(int totalCount) async {
    final currentIndex = getHadithCurrentIndex();
    final nextIndex = (currentIndex + 1) % totalCount;

    // If we completed the cycle, reshuffle
    if (nextIndex == 0) {
      final newShuffle = _generateShuffledIndices(totalCount);
      await _saveHadithShuffledIndices(newShuffle);
    }

    await saveHadithCurrentIndex(nextIndex);
    await resetHadithViewedStatus();
  }

  /// Advance to next sunnah (called when user views it and day ends)
  Future<void> advanceSunnah(int totalCount) async {
    final currentIndex = getSunnahCurrentIndex();
    final nextIndex = (currentIndex + 1) % totalCount;

    // If we completed the cycle, reshuffle
    if (nextIndex == 0) {
      final newShuffle = _generateShuffledIndices(totalCount);
      await _saveSunnahShuffledIndices(newShuffle);
    }

    await saveSunnahCurrentIndex(nextIndex);
    await resetSunnahViewedStatus();
  }

  /// Get current hadith from the shuffled list
  Future<DailyContentModel> getCurrentHadith(
    List<DailyContentModel> allHadiths,
  ) async {
    final shuffledIndices = await getHadithShuffledIndices(allHadiths.length);
    final currentIndex = getHadithCurrentIndex();
    final actualIndex = shuffledIndices[currentIndex];
    return allHadiths[actualIndex];
  }

  /// Get current sunnah from the shuffled list
  Future<DailyContentModel> getCurrentSunnah(
    List<DailyContentModel> allSunnah,
  ) async {
    final shuffledIndices = await getSunnahShuffledIndices(allSunnah.length);
    final currentIndex = getSunnahCurrentIndex();
    final actualIndex = shuffledIndices[currentIndex];
    return allSunnah[actualIndex];
  }

  /// Get all favorites
  List<DailyContentModel> getFavorites() {
    final stored = _prefs.getString(_favoritesKey);
    if (stored == null) return [];
    final decoded = json.decode(stored) as List<dynamic>;
    return decoded
        .map((item) => DailyContentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Save favorites list
  Future<void> _saveFavorites(List<DailyContentModel> favorites) async {
    await _prefs.setString(
      _favoritesKey,
      json.encode(favorites.map((e) => e.toJson()).toList()),
    );
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(DailyContentModel item) async {
    final favorites = getFavorites();
    final index = favorites.indexWhere(
      (f) => f.content == item.content && f.header == item.header,
    );

    if (index != -1) {
      favorites.removeAt(index);
      await _saveFavorites(favorites);
      return false; // Not favorite anymore
    } else {
      favorites.add(item);
      await _saveFavorites(favorites);
      return true; // Now favorite
    }
  }

  /// Check if item is favorite
  bool isFavorite(DailyContentModel? item) {
    if (item == null) return false;
    final favorites = getFavorites();
    return favorites.any(
      (f) => f.content == item.content && f.header == item.header,
    );
  }
}
