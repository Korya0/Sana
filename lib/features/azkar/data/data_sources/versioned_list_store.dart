import 'dart:async';
import 'dart:convert';

import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/utils/app_logger.dart';

abstract class VersionedListStore<T> {
  // Creates store
  VersionedListStore(
    AppKeyValueStore storage,
    AppLogger logger, {
    required this.storageKey,
    required this.unreadableKey,
    required this.versionKey,
    required this.itemsKey,
    required this.schemaVersion,
    required this.logScope,
    required this.itemLabel,
  }) : _storage = storage,
       _logger = logger;

  final AppKeyValueStore _storage;
  final AppLogger _logger;
  final String storageKey;
  final String unreadableKey;
  final String versionKey;
  final String itemsKey;
  final int schemaVersion;
  final String logScope;
  final String itemLabel;

  // Avoids re-decoding the whole blob on every read; invalidated on writes.
  List<T>? _cache;

  // Serializes writes so concurrent saves cannot overwrite each other.
  Future<void> _writeQueue = Future<void>.value();

  // Maps stored item
  T fromJson(Map<String, dynamic> json);

  // Encodes stored item
  Map<String, dynamic> toJson(T item);

  // Returns item id
  String idOf(T item);

  // Loads items
  Future<List<T>> loadItems() async => List.unmodifiable(await _load());

  // Saves item
  Future<void> saveItem(T item) => _enqueueWrite(() async {
    final currentList = List<T>.of(await _load());
    final index = currentList.indexWhere(
      (existing) => idOf(existing) == idOf(item),
    );

    if (index >= 0) {
      currentList[index] = item;
    } else {
      currentList.insert(0, item);
    }

    await _write(currentList);
  });

  // Deletes item
  Future<void> deleteItem(String id) => _enqueueWrite(() async {
    final currentList = List<T>.of(await _load());
    currentList.removeWhere((item) => idOf(item) == id);
    await _write(currentList);
  });

  // Queues write
  Future<R> _enqueueWrite<R>(Future<R> Function() action) {
    final completer = Completer<R>();
    _writeQueue = _writeQueue.then((_) async {
      try {
        completer.complete(await action());
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  // Loads cached data
  Future<List<T>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final rawJson = _storage.read<String>(storageKey);
    final decoded = _decode(rawJson);
    if (decoded != null) {
      _cache = decoded.items;
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

  // Decodes storage; accepts versioned envelope and legacy list.
  ({List<T> items, bool hadCorruption})? _decode(String? rawJson) {
    if (rawJson == null || rawJson.trim().isEmpty) {
      return (items: const [], hadCorruption: false);
    }

    final dynamic decoded;
    try {
      decoded = json.decode(rawJson);
    } on FormatException catch (error, stackTrace) {
      _logger.error(
        '$logScope: unreadable storage',
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
      _logger.error('$logScope: unexpected storage shape');
      return null;
    }

    final (version, items) = parsed;
    if (version > schemaVersion) {
      _logger.warning(
        '$logScope: newer schema $version, reading best effort',
      );
    }

    final result = <T>[];
    var hadCorruption = false;
    for (final item in items) {
      if (item is! Map<String, dynamic>) {
        hadCorruption = true;
        _logger.warning('$logScope: skipped a non-object $itemLabel');
        continue;
      }
      try {
        result.add(fromJson(item));
      } on Object catch (error, stackTrace) {
        hadCorruption = true;
        _logger.error(
          '$logScope: skipped a corrupt $itemLabel',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return (items: result, hadCorruption: hadCorruption);
  }

  // Writes storage
  Future<void> _write(List<T> items) async {
    final encoded = json.encode({
      versionKey: schemaVersion,
      itemsKey: items.map(toJson).toList(),
    });
    await _storage.write(storageKey, encoded);
    _cache = List.of(items);
  }

  // Backs up unreadable data
  Future<void> _backupUnreadable(String rawJson) async {
    try {
      // Keep the first copy to preserve recoverable data.
      final existing = _storage.read<String>(unreadableKey);
      if (existing != null) return;
      await _storage.write(unreadableKey, rawJson);
    } on Object catch (error, stackTrace) {
      _logger.error(
        '$logScope: failed to back up unreadable storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
