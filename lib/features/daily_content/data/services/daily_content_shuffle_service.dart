import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';

/// Manages shuffled indices for daily content categories.
/// Allows advancing through items in random order, reshuffling when all items
/// have been seen.
class DailyContentShuffleService {
  DailyContentShuffleService({required ILocalStorageService localStorageService})
      : _localStorageService = localStorageService;

  final ILocalStorageService _localStorageService;

  String _shuffledKey(String category) => '${category}_shuffled_indices';
  String _indexKey(String category) => '${category}_current_index';
  String _dateKey(String category) => '${category}_last_viewed_date';
  String _viewedStatusKey(String category) => '${category}_viewed_today';

  /// Gets the shuffled indices for a category, creating them if needed.
  Future<Result<List<int>>> getShuffledIndices(
    String category,
    int totalCount,
  ) async {
    final key = _shuffledKey(category);
    try {
      final stored = _localStorageService.getString(key);
      if (stored != null) {
        final decoded = json.decode(stored) as List<dynamic>;
        if (decoded.length == totalCount) {
          return Result.success(decoded.cast<int>());
        }
      }
      final shuffled = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _localStorageService.setString(key, json.encode(shuffled));
      return Result.success(shuffled);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn(
          'GetShuffledIndices Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.ourFault),
      );
    }
  }

  /// Advances the current index for a category, reshuffling if all items seen.
  Future<void> advanceIndex(String category, int totalCount) async {
    if (totalCount <= 0) return;
    final indexKey = _indexKey(category);
    final currentIndex = _localStorageService.getInt(indexKey) ?? 0;
    final nextIndex = (currentIndex + 1) % totalCount;

    if (nextIndex == 0) {
      final shuffleKey = _shuffledKey(category);
      final newShuffle = List<int>.generate(totalCount, (i) => i)
        ..shuffle(Random());
      await _localStorageService.setString(
        shuffleKey,
        json.encode(newShuffle),
      );
    }
    await _localStorageService.setInt(indexKey, nextIndex);
  }

  /// Gets the current index for a category.
  int getCurrentIndex(String category) =>
      _localStorageService.getInt(_indexKey(category)) ?? 0;

  /// Gets the last viewed date for a category.
  String? getLastViewedDate(String category) =>
      _localStorageService.getString(_dateKey(category));

  /// Sets the last viewed date for a category.
  Future<void> setLastViewedDate(String category, String date) async {
    await _localStorageService.setString(_dateKey(category), date);
  }

  /// Marks a category as viewed today.
  Future<void> markViewed(String category, String todayDate) async {
    await _localStorageService.setBoolean(_viewedStatusKey(category), true);
    await _localStorageService.setString(_dateKey(category), todayDate);
  }

  /// Resets the viewed status for a new day (marks as not yet viewed)
  /// and updates the last viewed date.
  Future<void> resetForNewDay(String category, String todayDate) async {
    await _localStorageService.setBoolean(_viewedStatusKey(category), false);
    await _localStorageService.setString(_dateKey(category), todayDate);
  }

  /// Checks if a category was viewed today.
  bool wasViewedToday(String category) =>
      _localStorageService.getBoolean(_viewedStatusKey(category)) ?? false;
}
