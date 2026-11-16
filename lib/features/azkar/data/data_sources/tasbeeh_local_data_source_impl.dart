import 'dart:async';
import 'dart:convert';

import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';

class TasbeehLocalDataSourceImpl implements TasbeehLocalDataSource {
  // Creates data source
  TasbeehLocalDataSourceImpl(this._storage, this._logger);

  final AppKeyValueStore _storage;
  final AppLogger _logger;

  // Avoids re-decoding the whole blob on every read; invalidated on writes.
  List<TasbeehItemModel>? _cache;

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

  // Loads items
  @override
  Future<List<TasbeehItemModel>> getItems() async =>
      List.unmodifiable(await _load());

  // Loads cached data
  Future<List<TasbeehItemModel>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final rawJson = _storage.read<String>(AppStorageKeys.tasbeehItems);
    final decoded = _decode(rawJson);
    if (decoded != null) {
      _cache = decoded.items;
      if (decoded.hadCorruption) {
        await _backupUnreadable(rawJson!);
      }
      return _cache!;
    }

    await _backupUnreadable(rawJson!);
    _cache = const [];
    return _cache!;
  }

  // Saves item
  @override
  Future<void> saveItem(TasbeehItemModel item) =>
      _enqueueWrite(() => _save(item));

  // Persists item
  Future<void> _save(TasbeehItemModel item) async {
    final currentList = List<TasbeehItemModel>.of(await getItems());
    final index = currentList.indexWhere((e) => e.id == item.id);

    if (index >= 0) {
      currentList[index] = item;
    } else {
      currentList.insert(0, item);
    }

    await _write(currentList);
  }

  // Deletes item
  @override
  Future<void> deleteItem(String id) => _enqueueWrite(() => _delete(id));

  // Removes item
  Future<void> _delete(String id) async {
    final currentList = List<TasbeehItemModel>.of(await getItems());
    currentList.removeWhere((item) => item.id == id);
    await _write(currentList);
  }

  // Decodes storage
  ({List<TasbeehItemModel> items, bool hadCorruption})? _decode(
    String? rawJson,
  ) {
    if (rawJson == null || rawJson.trim().isEmpty) {
      return (items: const [], hadCorruption: false);
    }

    final dynamic decoded;
    try {
      decoded = json.decode(rawJson);
    } on FormatException catch (error, stackTrace) {
      _logger.error(
        'TasbeehLocalDataSource: unreadable storage',
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
      _logger.error('TasbeehLocalDataSource: unexpected storage shape');
      return null;
    }

    final (version, items) = parsed;
    if (version > currentTasbeehSchemaVersion) {
      _logger.warning(
        'TasbeehLocalDataSource: newer schema $version, reading best effort',
      );
    }

    final result = <TasbeehItemModel>[];
    var hadCorruption = false;
    for (final item in items) {
      if (item is! Map<String, dynamic>) {
        hadCorruption = true;
        _logger.warning('TasbeehLocalDataSource: skipped a non-object item');
        continue;
      }
      try {
        result.add(TasbeehItemModel.fromJson(item));
      } on Object catch (error, stackTrace) {
        hadCorruption = true;
        _logger.error(
          'TasbeehLocalDataSource: skipped a corrupt item',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return (items: result, hadCorruption: hadCorruption);
  }

  // Writes storage
  Future<void> _write(List<TasbeehItemModel> items) async {
    final encoded = json.encode({
      tasbeehStorageVersionKey: currentTasbeehSchemaVersion,
      tasbeehStorageItemsKey: items.map((item) => item.toJson()).toList(),
    });
    await _storage.write(AppStorageKeys.tasbeehItems, encoded);
    _cache = List.of(items);
  }

  // Backs up unreadable data
  Future<void> _backupUnreadable(String rawJson) async {
    try {
      final existing = _storage.read<String>(
        AppStorageKeys.tasbeehItemsUnreadable,
      );
      if (existing != null) return;
      await _storage.write(AppStorageKeys.tasbeehItemsUnreadable, rawJson);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'TasbeehLocalDataSource: failed to back up unreadable storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
