import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';

void main() {
  group('AppStrings', () {
    test('formats the character counter', () {
      expect(AppStrings.charCounter(12, 200), '12 / 200');
    });

    test('formats the tasbeeh target max error', () {
      expect(
        AppStrings.tasbeehTargetMaxError(9999),
        'الحد الأقصى للعدد هو 9999',
      );
    });

    test('formats the tasbeeh selector semantics label', () {
      expect(
        AppStrings.tasbeehSelectorSemantics('سبحان الله'),
        '${AppStrings.chooseTasbeeh}: سبحان الله',
      );
    });
  });
}
