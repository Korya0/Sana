import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/skeletonizer_azkar_list.dart';

void main() {
  group('SkeletonizerAzkarList', () {
    testWidgets('should render skeleton items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: CustomScrollView(
              slivers: [SkeletonizerAzkarList()],
            ),
          ),
        ),
      );

      // Skeletonizer creates placeholder widgets
      expect(find.byType(SkeletonizerAzkarList), findsOneWidget);
    });
  });
}
