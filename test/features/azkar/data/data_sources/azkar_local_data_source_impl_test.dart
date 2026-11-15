import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const dataSource = AzkarLocalDataSourceImpl();

  test('loads every bundled category', () async {
    final categories = await dataSource.getCategories();

    expect(categories, isNotEmpty);
    expect(categories.every((category) => category.key.isNotEmpty), isTrue);
    expect(categories.every((category) => category.title.isNotEmpty), isTrue);
  });

  test('every bundled category has a readable azkar file', () async {
    final categories = await dataSource.getCategories();

    for (final category in categories) {
      expect(
        AppAssets.azkarCategory(category.key),
        isNotEmpty,
        reason: 'missing asset path for ${category.key}',
      );

      final azkar = await dataSource.getAzkarByCategory(category.key);
      expect(
        azkar,
        isNotEmpty,
        reason: 'empty azkar for ${category.key}',
      );
      expect(
        azkar.every((zikr) => zikr.text.isNotEmpty && zikr.count > 0),
        isTrue,
        reason: 'invalid zikr in ${category.key}',
      );
    }
  });
}
