import 'dart:async';
import 'dart:convert';

import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/daily_content/constants/daily_content_keys.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

/// Manages favorites for Daily Content items,
/// persisting them to local storage as JSON.
class DailyContentFavoritesService {
  DailyContentFavoritesService({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService {
    _cachedFavorites = _loadFromPrefs();
  }

  final LocalStorageService _localStorageService;

  static const String _favoritesKey = StorageKeys.dailyContentFavorites;
  List<DailyContentModel> _cachedFavorites = [];

  /// Toggles an item's favorite status. Returns `true` if now favorited.
  Future<bool> toggle(DailyContentModel item) async {
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
    await _persist();
    return isNowFavorite;
  }

  /// Checks if an item is in the favorites list.
  bool isFavorite(DailyContentModel? item) {
    if (item == null) return false;
    return _cachedFavorites.any(
      (f) => f.content == item.content && f.category == item.category,
    );
  }

  /// Returns all favorited items.
  List<DailyContentModel> getAll() => List.unmodifiable(_cachedFavorites);

  Future<void> _persist() async {
    await _localStorageService.setString(
      _favoritesKey,
      json.encode(_cachedFavorites.map((e) => e.toJson()).toList()),
    );
  }

  List<DailyContentModel> _loadFromPrefs() {
    final stored = _localStorageService.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = json.decode(stored) as List<dynamic>;
      final result = <DailyContentModel>[];
      for (final e in decoded) {
        try {
          final map = e as Map<String, dynamic>;
          final categoryName = map[DailyContentKeys.category] as String?;
          if (categoryName == null) {
            unawaited(
              AppLogger.localError('Category is null for favorite item: $map'),
            );
          }
          final category = categoryName == DailyContentType.sunnah.name
              ? DailyContentType.sunnah
              : DailyContentType.hadith;
          result.add(DailyContentModel.fromJson(map, category));
        } on Object catch (e, stack) {
          unawaited(
            AppLogger.localError(
              'Error parsing single favorite item',
              error: e,
              stackTrace: stack,
            ),
          );
        }
      }
      return result;
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'LoadFavorites Critical Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return [];
    }
  }
}
