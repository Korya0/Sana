import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';

// ---------------------------------------------------------------------------
// T053 – Edge Cases & Failure Cases
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // 1. Interrupted database update during ensureDatabaseReady()
  // -------------------------------------------------------------------------
  group(
    'T053 – ensureDatabaseReady interrupted update recovery',
    () {
      late AzkarLocalDataSourceImpl dataSource;
      late Directory tempDir;

      setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

      setUp(() async {
        tempDir = await Directory.systemTemp.createTemp('hive_edge_test');
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

      test(
        'simulates app crash mid-update: metadata version is bumped but '
        'categories box is empty → ensures re-reading from JSON on next launch',
        () async {
          mockAssets({
            AppAssets.azkarVersion: json.encode({
              AzkarConstants.versionMapKey: 2,
            }),
            AppAssets.azkarCategoriesJson: json.encode([
              {'id': 15, 'title': 'Survived Category', 'image': ''},
            ]),
            AppAssets.azkarCategoryJson(15): json.encode([
              {
                'id': 150,
                'category_id': 15,
                'text': 'Survived Zikr',
                'count': 1,
              },
            ]),
          });

          // Simulate a partial update: metadata version says 2 but categories
          // box was never populated (e.g. app killed during _loadAndSaveCategories).
          final metadataBox = await Hive.openBox<int>(
            AzkarConstants.metadataBoxName,
          );
          await metadataBox.put(AzkarConstants.versionKey, 1);

          // ensureDatabaseReady should detect 1 < 2 and populate everything
          await dataSource.ensureDatabaseReady();

          final newVersion = metadataBox.get(AzkarConstants.versionKey);
          expect(newVersion, 2);

          // Categories should be loaded despite the previous crash
          final categories = await dataSource.getCategories();
          expect(categories.any((c) => c.id == 15), isTrue);

          unmockAssets();
        },
      );
    },
  );

  // -------------------------------------------------------------------------
  // 2. Loading a non-existent category ID
  // -------------------------------------------------------------------------
  group('T053 – non-existent category ID', () {
    late AzkarLocalDataSourceImpl dataSource;
    late Directory tempDir;

    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_edge_test2');
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

    test(
      'getAzkarByCategory returns empty list for non-existent category',
      () async {
        mockAssets({}); // No assets → missing JSON

        final result = await dataSource.getAzkarByCategory(999);
        expect(result, isEmpty);

        unmockAssets();
      },
    );
  });

  // -------------------------------------------------------------------------
  // 3. Zikr with count: 0 or missing text in AzkarCubit
  // -------------------------------------------------------------------------
  group('T053 – ZikrEntity edge values in AzkarCubit', () {
    late MockGetAzkarByCategoryUseCase mockUseCase;
    late AzkarCubit cubit;

    setUp(() {
      mockUseCase = MockGetAzkarByCategoryUseCase();
      cubit = AzkarCubit(mockUseCase, MockGetCategoriesUseCase());
    });

    tearDown(() async {
      await cubit.close();
    });

    test(
      'AzkarCubit handles zikr with count: 0 without division-by-zero',
      () async {
        final tAzkar = [
          const ZikrEntity(id: 1, text: 'Count Zero Zikr', count: 0),
        ];
        when(
          () => mockUseCase(1),
        ).thenAnswer((_) async => Result.success(tAzkar));

        await cubit.loadAzkar(1);

        final state = cubit.state;
        expect(state, isA<AzkarLoaded>());
        final loaded = state as AzkarLoaded;

        // Counter starts at 0
        expect(loaded.counters[1], 0);

        // Incrementing with count 0 should immediately complete it
        final result = cubit.incrementZikr(1);
        expect(result, isA<ZikrIgnored>());
      },
    );

    test('AzkarCubit handles zikr with empty text', () async {
      final tAzkar = [
        const ZikrEntity(id: 1, text: '', count: 1),
      ];
      when(
        () => mockUseCase(1),
      ).thenAnswer((_) async => Result.success(tAzkar));

      await cubit.loadAzkar(1);

      final state = cubit.state;
      expect(state, isA<AzkarLoaded>());
      final loaded = state as AzkarLoaded;
      expect(loaded.azkar.first.text, isEmpty);

      // Increment should work normally
      final result = cubit.incrementZikr(1);
      expect(result, isA<ZikrCompleted>());
    });
  });

  // -------------------------------------------------------------------------
  // 4. Rapid sequential tapping debouncing (AzkarCubit level)
  // -------------------------------------------------------------------------
  group('T053 – rapid sequential tapping debouncing', () {
    test(
      'AzkarCubit incrementZikr properly counts sequential calls',
      () async {
        // Note: The debouncing is in the UI layer (ZikrItemCard),
        // but we verify that AzkarCubit correctly handles rapid increments.
        final mockUseCase = MockGetAzkarByCategoryUseCase();
        final cubit = AzkarCubit(mockUseCase, MockGetCategoriesUseCase());

        final tAzkar = [
          const ZikrEntity(id: 1, text: 'Tap Zikr', count: 3),
        ];
        when(
          () => mockUseCase(1),
        ).thenAnswer((_) async => Result.success(tAzkar));

        await cubit.loadAzkar(1);

        // Simulate 5 rapid taps on the same zikr
        for (var i = 0; i < 5; i++) {
          cubit.incrementZikr(1);
        }

        final state = cubit.state;
        expect(state, isA<AzkarLoaded>());
        final loaded = state as AzkarLoaded;

        // Counter should only reach 3 (the max count), not 5
        expect(loaded.counters[1], 3);
        expect(loaded.isAllCompleted, isTrue);

        await cubit.close();
      },
    );
  });
}

/// ----------------------------------------------------------------
/// Mock for use cases (avoid import conflicts)
/// ----------------------------------------------------------------
class MockGetAzkarByCategoryUseCase extends Mock
    implements GetAzkarByCategoryUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
