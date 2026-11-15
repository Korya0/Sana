import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

void main() {
  late _FakeKeyValueStore store;
  late CustomAzkarLocalDataSourceImpl dataSource;

  setUp(() {
    store = _FakeKeyValueStore();
    dataSource = CustomAzkarLocalDataSourceImpl(store, const _SilentLogger());
  });

  test('returns an empty list when nothing is stored', () async {
    expect(await dataSource.getCustomCategories(), isEmpty);
  });

  test('saves a new category and reads it back', () async {
    await dataSource.saveCustomCategory(_category('custom_1', name: 'أذكاري'));

    final categories = await dataSource.getCustomCategories();

    expect(categories, hasLength(1));
    expect(categories.single.id, 'custom_1');
    expect(categories.single.name, 'أذكاري');
  });

  test('writes a versioned envelope', () async {
    await dataSource.saveCustomCategory(_category('custom_1'));

    final decoded =
        json.decode(store.raw[AppStorageKeys.customAzkar] as String)
            as Map<String, dynamic>;

    expect(decoded[azkarStorageVersionKey], currentCustomAzkarSchemaVersion);
    expect(decoded[azkarStorageItemsKey], isA<List<dynamic>>());
  });

  test('keeps the newest category first', () async {
    await dataSource.saveCustomCategory(_category('custom_1'));
    await dataSource.saveCustomCategory(_category('custom_2'));

    final categories = await dataSource.getCustomCategories();

    expect(categories.map((c) => c.id), ['custom_2', 'custom_1']);
  });

  test('updates an existing category without duplicating it', () async {
    await dataSource.saveCustomCategory(_category('custom_1', name: 'قديم'));
    await dataSource.saveCustomCategory(_category('custom_1', name: 'جديد'));

    final categories = await dataSource.getCustomCategories();

    expect(categories, hasLength(1));
    expect(categories.single.name, 'جديد');
  });

  test('deletes a category by id', () async {
    await dataSource.saveCustomCategory(_category('custom_1'));
    await dataSource.saveCustomCategory(_category('custom_2'));

    await dataSource.deleteCustomCategory('custom_1');

    final categories = await dataSource.getCustomCategories();
    expect(categories.map((c) => c.id), ['custom_2']);
  });

  test('finds a category by id and returns null when missing', () async {
    await dataSource.saveCustomCategory(_category('custom_1', name: 'قسمي'));

    final found = await dataSource.getCustomCategoryById('custom_1');
    final missing = await dataSource.getCustomCategoryById('custom_9');

    expect(found?.name, 'قسمي');
    expect(missing, isNull);
  });

  test('reads legacy bare-list data', () async {
    store.raw[AppStorageKeys.customAzkar] = json.encode([
      _category('custom_1', name: 'قديم').toJson(),
    ]);

    final categories = await dataSource.getCustomCategories();

    expect(categories.single.name, 'قديم');
  });

  test('skips a corrupt item and keeps the valid ones', () async {
    store.raw[AppStorageKeys.customAzkar] = json.encode([
      _category('custom_1', name: 'سليم').toJson(),
      'غير صالح',
      {azkarIdKey: 7},
    ]);

    final categories = await dataSource.getCustomCategories();

    expect(categories, hasLength(1));
    expect(categories.single.name, 'سليم');
  });

  test('backs up the raw blob when a category is skipped', () async {
    final raw = json.encode([
      _category('custom_1', name: 'سليم').toJson(),
      {azkarIdKey: 7},
    ]);
    store.raw[AppStorageKeys.customAzkar] = raw;

    await dataSource.getCustomCategories();

    expect(store.raw[AppStorageKeys.customAzkarUnreadable], raw);
  });

  test('keeps the first backup instead of overwriting it', () async {
    store.raw[AppStorageKeys.customAzkarUnreadable] = 'older backup';
    store.raw[AppStorageKeys.customAzkar] = json.encode([
      {azkarIdKey: 7},
    ]);

    await dataSource.getCustomCategories();

    expect(store.raw[AppStorageKeys.customAzkarUnreadable], 'older backup');
  });

  test('backs up unreadable data and returns an empty list', () async {
    const unreadable = '{not valid json';
    store.raw[AppStorageKeys.customAzkar] = unreadable;

    final categories = await dataSource.getCustomCategories();

    expect(categories, isEmpty);
    expect(
      store.raw[AppStorageKeys.customAzkarUnreadable],
      unreadable,
    );
  });

  test('reads storage once for repeated reads', () async {
    await dataSource.saveCustomCategory(_category('custom_1'));

    await dataSource.getCustomCategories();
    await dataSource.getCustomCategories();
    await dataSource.getCustomCategories();

    expect(store.readCount, 1);
  });

  test('keeps the cache in sync after a save and delete', () async {
    await dataSource.saveCustomCategory(_category('custom_1'));
    await dataSource.getCustomCategories();

    await dataSource.saveCustomCategory(_category('custom_2'));
    expect(
      (await dataSource.getCustomCategories()).map((c) => c.id),
      ['custom_2', 'custom_1'],
    );

    await dataSource.deleteCustomCategory('custom_1');
    expect(
      (await dataSource.getCustomCategories()).map((c) => c.id),
      ['custom_2'],
    );
    expect(store.readCount, 1);
  });

  test('does not expose the cache for mutation', () async {
    await dataSource.saveCustomCategory(_category('custom_1'));

    final firstRead = await dataSource.getCustomCategories();
    expect(() => firstRead.clear(), throwsUnsupportedError);

    expect(await dataSource.getCustomCategories(), hasLength(1));
  });

  test('serializes concurrent writes so none is lost', () async {
    final slowStore = _FakeKeyValueStore(
      writeDelay: const Duration(milliseconds: 20),
    );
    final slowDataSource = CustomAzkarLocalDataSourceImpl(
      slowStore,
      const _SilentLogger(),
    );

    await Future.wait([
      slowDataSource.saveCustomCategory(_category('custom_1')),
      slowDataSource.saveCustomCategory(_category('custom_2')),
      slowDataSource.saveCustomCategory(_category('custom_3')),
    ]);

    final ids = (await slowDataSource.getCustomCategories())
        .map((category) => category.id)
        .toSet();

    expect(ids, {'custom_1', 'custom_2', 'custom_3'});
  });

  test('keeps accepting writes after one fails', () async {
    store.failuresLeft = 1;

    await expectLater(
      dataSource.saveCustomCategory(_category('custom_1')),
      throwsA(isA<StateError>()),
    );

    await dataSource.saveCustomCategory(_category('custom_2'));

    expect(
      (await dataSource.getCustomCategories()).map((category) => category.id),
      ['custom_2'],
    );
  });
}

CustomCategoryModel _category(
  String id, {
  String name = 'قسم',
  List<ZikrModel> azkar = const [],
}) => CustomCategoryModel(id: id, name: name, azkar: azkar);

class _FakeKeyValueStore implements AppKeyValueStore {
  _FakeKeyValueStore({this.writeDelay});

  final Map<String, dynamic> raw = {};
  final Duration? writeDelay;
  int readCount = 0;
  int failuresLeft = 0;

  @override
  T? read<T>(String key) {
    readCount++;
    return raw[key] as T?;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    if (writeDelay != null) await Future<void>.delayed(writeDelay!);
    if (failuresLeft > 0) {
      failuresLeft--;
      throw StateError('write failed');
    }
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
