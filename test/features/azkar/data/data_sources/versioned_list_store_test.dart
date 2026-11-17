import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/versioned_list_store.dart';

void main() {
  late _FakeKeyValueStore store;
  late _StringListStore listStore;

  setUp(() {
    store = _FakeKeyValueStore();
    listStore = _StringListStore(store);
  });

  Map<String, dynamic> envelope(
    List<Map<String, dynamic>> items, {
    int v = 1,
  }) => {'version': v, 'items': items};
  Map<String, dynamic> entry(String value) => {'value': value};

  test('writes a versioned envelope', () async {
    await listStore.saveItem('a');

    final decoded =
        json.decode(store.raw['storage_key'] as String) as Map<String, dynamic>;

    expect(decoded['version'], 1);
    expect(decoded['items'], [entry('a')]);
  });

  test('deletes an item', () async {
    await listStore.saveItem('a');
    await listStore.saveItem('b');

    await listStore.deleteItem('a');

    expect(await listStore.loadItems(), ['b']);
  });

  test('reads a legacy plain list', () async {
    store.raw['storage_key'] = json.encode([entry('legacy')]);

    expect(await listStore.loadItems(), ['legacy']);
  });

  test('reads an envelope without a version', () async {
    store.raw['storage_key'] = json.encode({
      'items': [entry('v1')],
    });

    expect(await listStore.loadItems(), ['v1']);
  });

  test('best-effort reads a newer schema', () async {
    store.raw['storage_key'] = json.encode(
      envelope([entry('future')], v: 99),
    );

    expect(await listStore.loadItems(), ['future']);
  });

  test('backs up unreadable data and returns an empty list', () async {
    store.raw['storage_key'] = 'broken';

    expect(await listStore.loadItems(), isEmpty);
    expect(store.raw['unreadable_key'], 'broken');
  });

  test('keeps the first backup', () async {
    store.raw['storage_key'] = 'first';
    await listStore.loadItems();
    store.raw['storage_key'] = 'second';
    await listStore.loadItems();

    expect(store.raw['unreadable_key'], 'first');
  });

  test('skips non-object entries', () async {
    store.raw['storage_key'] = json.encode({
      'version': 1,
      'items': [42, entry('ok')],
    });

    expect(await listStore.loadItems(), ['ok']);
  });

  test('returns an unmodifiable list', () async {
    await listStore.saveItem('a');

    final items = await listStore.loadItems();

    expect(() => items.add('b'), throwsA(isA<UnsupportedError>()));
  });

  test('reuses the cache between reads', () async {
    await listStore.saveItem('a');
    final reads = store.readCount;

    await listStore.loadItems();
    await listStore.loadItems();

    expect(store.readCount, reads);
  });

  test('serializes concurrent writes', () async {
    store.writeDelay = const Duration(milliseconds: 5);

    await Future.wait([
      listStore.saveItem('a'),
      listStore.saveItem('b'),
      listStore.saveItem('c'),
    ]);

    expect(await listStore.loadItems(), hasLength(3));
  });
}

class _StringListStore extends VersionedListStore<String> {
  _StringListStore(AppKeyValueStore store)
    : super(
        store,
        const _SilentLogger(),
        storageKey: 'storage_key',
        unreadableKey: 'unreadable_key',
        versionKey: 'version',
        itemsKey: 'items',
        schemaVersion: 1,
        logScope: 'TestStore',
        itemLabel: 'item',
      );

  @override
  String fromJson(Map<String, dynamic> json) => json['value'] as String;

  @override
  Map<String, dynamic> toJson(String item) => {'value': item};

  @override
  String idOf(String item) => item;
}

class _FakeKeyValueStore implements AppKeyValueStore {
  final Map<String, dynamic> raw = {};
  Duration? writeDelay;
  int readCount = 0;

  @override
  T? read<T>(String key) {
    readCount++;
    return raw[key] as T?;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    if (writeDelay != null) await Future<void>.delayed(writeDelay!);
    raw[key] = value;
  }

  @override
  Future<void> delete(String key) async => raw.remove(key);
}

class _SilentLogger extends AppLogger {
  const _SilentLogger();

  @override
  void warning(String message) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
