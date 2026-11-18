import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';

void main() {
  group('AzkarCategoriesState', () {
    test('AzkarCategoriesInitial is a state', () {
      final state = AzkarCategoriesInitial();
      expect(state, isA<AzkarCategoriesState>());
    });

    test('AzkarCategoriesLoading is a state', () {
      final state = AzkarCategoriesLoading();
      expect(state, isA<AzkarCategoriesState>());
    });

    test('AzkarCategoriesLoaded stores categories', () {
      const categories = [
        AzkarCategoryEntity(key: 'morning', title: 'صباح', cardTitle: 'صباح'),
      ];
      const state = AzkarCategoriesLoaded(categories);

      expect(state, isA<AzkarCategoriesState>());
      expect(state.categories, same(categories));
      expect(state.categories.single.key, 'morning');
    });

    test('AzkarCategoriesLoaded can hold an empty list', () {
      const state = AzkarCategoriesLoaded([]);
      expect(state.categories, isEmpty);
    });

    test('AzkarCategoriesEmpty is a state', () {
      final state = AzkarCategoriesEmpty();
      expect(state, isA<AzkarCategoriesState>());
    });

    test('AzkarCategoriesError stores the message', () {
      const state = AzkarCategoriesError('boom');

      expect(state, isA<AzkarCategoriesState>());
      expect(state.message, 'boom');
    });

    test('AzkarCategoriesError can hold an empty message', () {
      const state = AzkarCategoriesError('');
      expect(state.message, isEmpty);
    });
  });
}
