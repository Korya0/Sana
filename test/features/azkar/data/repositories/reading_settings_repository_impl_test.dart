import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';

void main() {
  group('ReadingSettingsRepositoryImpl', () {
    test('returns the default size when nothing is saved', () async {
      final repository = ReadingSettingsRepositoryImpl(
        _FakeKeyValueStore(),
        const _SilentLogger(),
      );

      final result = await repository.getReadingSettings();

      final success = result as Success<ReadingSettingsEntity>;
      expect(success.data.fontSize, ReadingSettingsEntity.defaultFontSize);
    });

    test('returns the saved size', () async {
      final store = _FakeKeyValueStore();
      store.values[AppStorageKeys.azkarFontSize] = 26.0;
      final repository = ReadingSettingsRepositoryImpl(
        store,
        const _SilentLogger(),
      );

      final result = await repository.getReadingSettings();

      final success = result as Success<ReadingSettingsEntity>;
      expect(success.data.fontSize, 26);
    });

    test('writes the new size', () async {
      final store = _FakeKeyValueStore();
      final repository = ReadingSettingsRepositoryImpl(
        store,
        const _SilentLogger(),
      );

      final result = await repository.updateReadingSettings(
        ReadingSettingsEntity(fontSize: 28),
      );

      expect(result, isA<Success<void>>());
      expect(store.values[AppStorageKeys.azkarFontSize], 28);
    });

    test('reports a save error when writing fails', () async {
      final repository = ReadingSettingsRepositoryImpl(
        _FakeKeyValueStore(failWrites: true),
        const _SilentLogger(),
      );

      final result = await repository.updateReadingSettings(
        ReadingSettingsEntity(fontSize: 22),
      );

      expect(_messageOf(result), AppStrings.saveSettingsError);
    });

    test('reports a load error when reading fails', () async {
      final repository = ReadingSettingsRepositoryImpl(
        _FakeKeyValueStore(failReads: true),
        const _SilentLogger(),
      );

      final result = await repository.getReadingSettings();

      expect(_messageOf(result), AppStrings.loadSettingsError);
    });
  });
}

String _messageOf(Result<Object?> result) =>
    (result as FailureResult<Object?>).failure.message;

class _FakeKeyValueStore implements AppKeyValueStore {
  _FakeKeyValueStore({this.failReads = false, this.failWrites = false});

  final Map<String, dynamic> values = {};
  final bool failReads;
  final bool failWrites;

  @override
  T? read<T>(String key) {
    if (failReads) throw StateError('read failed');
    return values[key] as T?;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    if (failWrites) throw StateError('write failed');
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async => values.remove(key);
}

class _SilentLogger extends AppLogger {
  const _SilentLogger();

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
