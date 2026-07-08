import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source_impl.dart';

void main() {
  late AzkarLocalDataSourceImpl dataSource;
  late Directory tempDir;

  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    dataSource = AzkarLocalDataSourceImpl();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  void mockAssets(Map<String, String> assets) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
          if (message == null) return null;
          final buffer = message.buffer.asUint8List(
            message.offsetInBytes,
            message.lengthInBytes,
          );
          final assetKey = utf8.decode(buffer);
          if (assets.containsKey(assetKey)) {
            return ByteData.view(
              Uint8List.fromList(utf8.encode(assets[assetKey]!)).buffer,
            );
          }
          return null;
        });
  }

  void unmockAssets() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  }

  group('AzkarLocalDataSourceImpl', () {
    test(
      'ensureDatabaseReady updates database when version is newer',
      () async {
        mockAssets({
          AppAssets.azkarVersion: json.encode({
            AzkarConstants.versionMapKey: 2,
          }),
          AppAssets.azkarCategoriesJson: json.encode([
            {'id': 1, 'title': 'Category 1', 'image': 'assets/images/cat1.png'},
          ]),
          AppAssets.azkarCategoryJson(1): json.encode([
            {'id': 1, 'category_id': 1, 'text': 'Zikr 1', 'count': 1},
          ]),
        });

        // Initialize with version 1
        final metadataBox = await Hive.openBox<int>(
          AzkarConstants.metadataBoxName,
        );
        await metadataBox.put(AzkarConstants.versionKey, 1);

        await dataSource.ensureDatabaseReady();

        final newVersion = metadataBox.get(AzkarConstants.versionKey);
        expect(newVersion, 2);

        final categories = await dataSource.getCategories();
        expect(categories.length, 1);
        expect(categories.first.id, 1);

        unmockAssets();
      },
    );

    test('ensureDatabaseReady skips update if version is equal', () async {
      mockAssets({
        AppAssets.azkarVersion: json.encode({AzkarConstants.versionMapKey: 2}),
      });

      final metadataBox = await Hive.openBox<int>(
        AzkarConstants.metadataBoxName,
      );
      await metadataBox.put(AzkarConstants.versionKey, 2);

      // Box should be empty because we skip update
      await dataSource.ensureDatabaseReady();
      final catBox = await Hive.openBox<String>(
        AzkarConstants.categoriesBoxName,
      );
      expect(catBox.isEmpty, true);

      unmockAssets();
    });

    test(
      'getAzkarByCategory dynamically loads and caches JSON if box is empty',
      () async {
        mockAssets({
          AppAssets.azkarCategoryJson(5): json.encode([
            {'id': 10, 'category_id': 5, 'text': 'Zikr 10', 'count': 3},
          ]),
        });

        // Box should be empty initially
        final box = await Hive.openBox<String>(
          '${AzkarConstants.azkarCategoryBoxPrefix}5',
        );
        expect(box.isEmpty, true);

        // Call should parse JSON and populate box
        final azkar = await dataSource.getAzkarByCategory(5);

        expect(azkar.length, 1);
        expect(azkar.first.id, 10);
        expect(box.isEmpty, false);
        expect(box.length, 1);

        unmockAssets();
      },
    );

    test(
      'getCategories skips malformed category JSON items without crashing',
      () async {
        mockAssets({
          AppAssets.azkarVersion: json.encode({
            AzkarConstants.versionMapKey: 3,
          }),
          AppAssets.azkarCategoriesJson: json.encode([
            {'id': 1, 'title': 'Valid Category'},
            {'title': 'Invalid Category Missing ID'},
          ]),
        });

        await dataSource.ensureDatabaseReady();

        final categories = await dataSource.getCategories();
        expect(categories.length, 1);
        expect(categories.first.id, 1);

        unmockAssets();
      },
    );

    test(
      'getAzkarByCategory handles missing asset gracefully and returns empty list',
      () async {
        mockAssets({}); // No assets defined

        final result = await dataSource.getAzkarByCategory(99);
        expect(result, isEmpty);

        unmockAssets();
      },
    );
  });
}
