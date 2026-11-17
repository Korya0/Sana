import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';

void main() {
  late _FakeKeyValueStore store;
  late TasbeehLocalDataSourceImpl dataSource;

  setUp(() {
    store = _FakeKeyValueStore();
    dataSource = TasbeehLocalDataSourceImpl(store, const _SilentLogger());
  });

  TasbeehItemModel item(String id) => TasbeehItemModel(
    id: id,
    text: 'ذكر $id',
    currentCount: 0,
    lastUsedAt: DateTime(2026, 11, 17),
  );

  test('returns an empty list when nothing is stored', () async {
    expect(await dataSource.getTasbeehItems(), isEmpty);
  });

  test('saves an item and reads it back', () async {
    await dataSource.saveTasbeehItem(item('t1'));

    final items = await dataSource.getTasbeehItems();

    expect(items, hasLength(1));
    expect(items.single.id, 't1');
  });

  test('writes a versioned envelope with tasbeeh keys', () async {
    await dataSource.saveTasbeehItem(item('t1'));

    final decoded =
        json.decode(store.raw[AppStorageKeys.tasbeehItems] as String)
            as Map<String, dynamic>;

    expect(decoded[tasbeehStorageVersionKey], currentTasbeehSchemaVersion);
    expect(decoded[tasbeehStorageItemsKey], isA<List<dynamic>>());
  });

  test('deletes an item', () async {
    await dataSource.saveTasbeehItem(item('t1'));
    await dataSource.saveTasbeehItem(item('t2'));

    await dataSource.deleteTasbeehItem('t1');

    expect(
      (await dataSource.getTasbeehItems()).map((e) => e.id),
      ['t2'],
    );
  });

  test('accepts a legacy plain list', () async {
    store.raw[AppStorageKeys.tasbeehItems] = json.encode([
      item('legacy').toJson(),
    ]);

    expect((await dataSource.getTasbeehItems()).single.id, 'legacy');
  });

  test('accepts an envelope without a version', () async {
    store.raw[AppStorageKeys.tasbeehItems] = json.encode({
      tasbeehStorageItemsKey: [item('v1').toJson()],
    });

    expect((await dataSource.getTasbeehItems()).single.id, 'v1');
  });

  test('backs up unreadable raw storage without overwriting it', () async {
    store.raw[AppStorageKeys.tasbeehItems] = 'not json';

    expect(await dataSource.getTasbeehItems(), isEmpty);
    expect(
      store.raw[AppStorageKeys.tasbeehItemsUnreadable],
      'not json',
    );

    store.raw[AppStorageKeys.tasbeehItems] = 'other broken data';
    await dataSource.getTasbeehItems();
    expect(
      store.raw[AppStorageKeys.tasbeehItemsUnreadable],
      'not json',
    );
  });

  test('skips corrupt items and keeps valid ones', () async {
    store.raw[AppStorageKeys.tasbeehItems] = json.encode({
      tasbeehStorageVersionKey: currentTasbeehSchemaVersion,
      tasbeehStorageItemsKey: ['bad', item('good').toJson()],
    });

    expect((await dataSource.getTasbeehItems()).map((e) => e.id), ['good']);
  });

  test('exposes JSON mapping and id lookup directly', () {
    final model = item('t1');

    expect(dataSource.fromJson(model.toJson()), model);
    expect(dataSource.toJson(model)[tasbeehIdKey], 't1');
    expect(dataSource.idOf(model), 't1');
  });

  test('caches reads and invalidates the cache on write', () async {
    await dataSource.saveTasbeehItem(item('t1'));
    final readsBefore = store.readCount;

    await dataSource.getTasbeehItems();
    await dataSource.getTasbeehItems();

    expect(store.readCount, readsBefore);

    await dataSource.saveTasbeehItem(item('t2'));
    expect((await dataSource.getTasbeehItems()).map((e) => e.id), ['t2', 't1']);
  });

  test('serializes concurrent writes', () async {
    store.writeDelay = const Duration(milliseconds: 5);

    await Future.wait([
      dataSource.saveTasbeehItem(item('t1')),
      dataSource.saveTasbeehItem(item('t2')),
      dataSource.saveTasbeehItem(item('t3')),
    ]);

    expect(await dataSource.getTasbeehItems(), hasLength(3));
  });
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
