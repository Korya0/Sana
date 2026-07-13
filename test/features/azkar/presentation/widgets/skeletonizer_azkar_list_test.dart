import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/skeletonizer_azkar_list.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('SkeletonizerAzkarList', () {
    testWidgets('renders 4 skeleton item containers', (tester) async {
      setTestScreenSize(tester);
      await tester.pumpWidget(
        createTestApp(
          const CustomScrollView(
            slivers: [SkeletonizerAzkarList()],
          ),
        ),
      );

      // Skeletonizer uses infinite shimmer → use pump() instead of pumpAndSettle()
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SliverList), findsOneWidget);

      expect(
        find.text(
          'محتوى تجريبي طويل ليظهر بنفس المساحة تماما محتوى تجريبي طويل ليظهر بنفس المساحة تماما',
        ),
        findsWidgets,
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('includes share/copy actions in skeleton', (tester) async {
      setTestScreenSize(tester);
      await tester.pumpWidget(
        createTestApp(
          const CustomScrollView(
            slivers: [SkeletonizerAzkarList()],
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CombinedShareCopyButton), findsWidgets);
    });
  });
}
