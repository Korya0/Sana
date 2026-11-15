import 'dart:async';
import 'dart:convert';

import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';

class CustomAzkarLocalDataSourceImpl implements CustomAzkarLocalDataSource {
  // Creates data source
  CustomAzkarLocalDataSourceImpl(this._storage, this._logger);

  final AppKeyValueStore _storage;
  final AppLogger _logger;

  // Avoids re-decoding the whole blob on every read; invalidated on writes.
  List<CustomCategoryModel>? _cache;

  // Serializes writes so concurrent saves cannot overwrite each other.
  Future<void> _writeQueue = Future<void>.value();

  // Queues write
  Future<T> _enqueueWrite<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _writeQueue = _writeQueue.then((_) async {
      try {
        completer.complete(await action());
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  // Loads categories
  @override
  Future<List<CustomCategoryModel>> getCustomCategories() async =>
      List.unmodifiable(await _load());

  // Loads cached data
  Future<List<CustomCategoryModel>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final rawJson = _storage.read<String>(AppStorageKeys.customAzkar);
    final decoded = _decode(rawJson);
    if (decoded != null) {
      _cache = decoded.categories;
      if (decoded.hadCorruption) {
        // Back up before a later write can overwrite partially unreadable data.
        await _backupUnreadable(rawJson!);
      }
      return _cache!;
    }

    // Preserve unreadable data before any future write.
    await _backupUnreadable(rawJson!);
    _cache = const [];
    return _cache!;
  }

  // Saves category
  @override
  Future<void> saveCustomCategory(CustomCategoryModel category) =>
      _enqueueWrite(() => _save(category));

  // Persists category
  Future<void> _save(CustomCategoryModel category) async {
    final currentList = List<CustomCategoryModel>.of(
      await getCustomCategories(),
    );
    final index = currentList.indexWhere((item) => item.id == category.id);

    if (index >= 0) {
      currentList[index] = category;
    } else {
      currentList.insert(0, category);
    }

    await _write(currentList);
  }

  // Deletes category
  @override
  Future<void> deleteCustomCategory(String id) =>
      _enqueueWrite(() => _delete(id));

  // Removes category
  Future<void> _delete(String id) async {
    final currentList = List<CustomCategoryModel>.of(
      await getCustomCategories(),
    );
    currentList.removeWhere((item) => item.id == id);
    await _write(currentList);
  }

  // Finds category
  @override
  Future<CustomCategoryModel?> getCustomCategoryById(String id) async {
    final currentList = await _load();
    for (final category in currentList) {
      if (category.id == id) return category;
    }
    return null;
  }

  // Decodes storage; accepts versioned envelope and legacy list.
  ({List<CustomCategoryModel> categories, bool hadCorruption})? _decode(
    String? rawJson,
  ) {
    if (rawJson == null || rawJson.trim().isEmpty) {
      return (categories: const [], hadCorruption: false);
    }

    final dynamic decoded;
    try {
      decoded = json.decode(rawJson);
    } on FormatException catch (error, stackTrace) {
      _logger.error(
        'CustomAzkarLocalDataSource: unreadable storage',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }

    final parsed = switch (decoded) {
      {'version': final int version, 'items': final List<dynamic> items} => (
        version,
        items,
      ),
      {'items': final List<dynamic> items} => (1, items),
      final List<dynamic> legacy => (1, legacy),
      _ => null,
    };
    if (parsed == null) {
      _logger.error('CustomAzkarLocalDataSource: unexpected storage shape');
      return null;
    }

    final (version, items) = parsed;
    if (version > currentCustomAzkarSchemaVersion) {
      _logger.warning(
        'CustomAzkarLocalDataSource: newer schema $version, reading best effort',
      );
    }

    final categories = <CustomCategoryModel>[];
    var hadCorruption = false;
    for (final item in items) {
      if (item is! Map<String, dynamic>) {
        hadCorruption = true;
        _logger.warning(
          'CustomAzkarLocalDataSource: skipped a non-object category',
        );
        continue;
      }
      try {
        categories.add(CustomCategoryModel.fromJson(item));
      } on Object catch (error, stackTrace) {
        hadCorruption = true;
        _logger.error(
          'CustomAzkarLocalDataSource: skipped a corrupt category',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return (categories: categories, hadCorruption: hadCorruption);
  }

  // Writes storage
  Future<void> _write(List<CustomCategoryModel> categories) async {
    final encoded = json.encode({
      azkarStorageVersionKey: currentCustomAzkarSchemaVersion,
      azkarStorageItemsKey: categories.map((item) => item.toJson()).toList(),
    });
    await _storage.write(AppStorageKeys.customAzkar, encoded);
    _cache = List.of(categories);
  }

  // Backs up unreadable data
  Future<void> _backupUnreadable(String rawJson) async {
    try {
      // Keep the first copy to preserve recoverable data.
      final existing = _storage.read<String>(
        AppStorageKeys.customAzkarUnreadable,
      );
      if (existing != null) return;
      await _storage.write(AppStorageKeys.customAzkarUnreadable, rawJson);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'CustomAzkarLocalDataSource: failed to back up unreadable storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
