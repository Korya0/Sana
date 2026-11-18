import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';

void main() {
  group('CustomAzkarState', () {
    test('CustomAzkarInitial is a state', () {
      const state = CustomAzkarInitial();
      expect(state, isA<CustomAzkarState>());
    });

    test('CustomAzkarLoading is a state', () {
      const state = CustomAzkarLoading();
      expect(state, isA<CustomAzkarState>());
    });

    test('CustomAzkarLoaded stores categories', () {
      const categories = [
        CustomCategoryEntity(id: 'custom_1', name: 'ورد', azkar: []),
      ];
      const state = CustomAzkarLoaded(categories);

      expect(state, isA<CustomAzkarState>());
      expect(state.categories, same(categories));
      expect(state.categories.single.id, 'custom_1');
    });

    test('CustomAzkarLoaded can hold an empty list', () {
      const state = CustomAzkarLoaded([]);
      expect(state.categories, isEmpty);
    });

    test('CustomAzkarEmpty is a state', () {
      const state = CustomAzkarEmpty();
      expect(state, isA<CustomAzkarState>());
    });

    test('CustomAzkarError stores the message', () {
      const state = CustomAzkarError('boom');

      expect(state, isA<CustomAzkarState>());
      expect(state.message, 'boom');
    });

    test('CustomAzkarError can hold an empty message', () {
      const state = CustomAzkarError('');
      expect(state.message, isEmpty);
    });
  });
}
