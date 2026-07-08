import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/constants/constants.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('AppErrorView', () {
    testWidgets('renders title and custom message', (tester) async {
      setTestScreenSize(tester);
      await tester.pumpWidget(
        createTestApp(
          const AppErrorView(message: 'Custom error message'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.errorWidgetTitle), findsOneWidget);
      expect(find.text('Custom error message'), findsOneWidget);
    });

    testWidgets(
      'renders without message when message is null',
      (tester) async {
        setTestScreenSize(tester);
        await tester.pumpWidget(
          createTestApp(const AppErrorView()),
        );

        await tester.pumpAndSettle();

        expect(find.text(AppStrings.errorWidgetTitle), findsOneWidget);
        expect(find.text('عذراً، حدث خطأ'), findsOneWidget);
      },
    );

    testWidgets('displays retry button when onRetry is provided', (tester) async {
      setTestScreenSize(tester);
      var retryCalled = false;

      await tester.pumpWidget(
        createTestApp(
          AppErrorView(
            message: 'Something went wrong',
            onRetry: () => retryCalled = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.tryAgain), findsOneWidget);

      await tester.tap(find.text(AppStrings.tryAgain));
      await tester.pumpAndSettle();

      expect(retryCalled, isTrue);
    });

    testWidgets('does not show retry button when onRetry is null', (tester) async {
      setTestScreenSize(tester);
      await tester.pumpWidget(
        createTestApp(
          const AppErrorView(message: 'Error without retry'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.tryAgain), findsNothing);
    });
  });
}
