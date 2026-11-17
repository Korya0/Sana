import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';

void main() {
  testWidgets('hides back on a root screen with nowhere to pop', (tester) async {
    await tester.pumpWidget(_app(home: _screen('Root')));

    expect(find.text('Root'), findsOneWidget);
    expect(find.byIcon(AppIcons.back), findsNothing);
  });

  testWidgets('shows back on a pushed screen and pops it', (tester) async {
    await tester.pumpWidget(
      _app(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => _screen('Pushed')),
                ),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('Pushed'), findsOneWidget);
    expect(find.byIcon(AppIcons.back), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.back));
    await tester.pumpAndSettle();

    expect(find.text('Pushed'), findsNothing);
  });

  testWidgets('keeps a custom back handler even when the navigator cannot pop', (
    tester,
  ) async {
    var handled = false;
    await tester.pumpWidget(
      _app(
        home: _screen(
          'Root',
          onBackPressed: () => handled = true,
        ),
      ),
    );

    await tester.tap(find.byIcon(AppIcons.back));
    await tester.pumpAndSettle();

    expect(handled, isTrue);
  });
}

Widget _screen(String title, {VoidCallback? onBackPressed}) => Scaffold(
  body: CustomScrollView(
    slivers: [
      CommonSliverAppBar(title: title, onBackPressed: onBackPressed),
    ],
  ),
);

Widget _app({required Widget home}) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) {
    AppSize.init(context);
    return Directionality(textDirection: TextDirection.rtl, child: child!);
  },
  home: home,
);
