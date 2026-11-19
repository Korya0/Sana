import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/custom_azkar_form_items_section.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_card.dart';

import 'azkar_widget_test_harness.dart';

const _longText =
    'سبحان الله وبحمده سبحان الله العظيم سبحان الله وبحمده '
    'سبحان الله العظيم سبحان الله وبحمده سبحان الله العظيم';

List<ZikrEntity> _items() => List.generate(
  30,
  (index) => ZikrEntity(id: index + 1, text: _longText, count: 3),
);

void main() {
  testWidgets('auto scrolls down while dragging toward the bottom', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = await createLoadedSettingsCubit();
    int? fromIndex;
    int? toIndex;

    await pumpAzkarSliver(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: CustomAzkarFormItemsSection(
          items: _items(),
          isBuiltIn: false,
          topInset: 0,
          onEdit: (_) {},
          onDelete: (_) {},
          onReorder: (from, to) {
            fromIndex = from;
            toIndex = to;
          },
        ),
      ),
    );

    final state = tester.state<ScrollableState>(find.byType(Scrollable));
    final gesture = await tester.startGesture(
      tester.getCenter(find.text(_longText).first),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    await gesture.moveTo(const Offset(200, 870));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(state.position.pixels, greaterThan(0));

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(toIndex, isNotNull);
    expect(toIndex, greaterThan(fromIndex!));
  });

  testWidgets('auto scrolls up while dragging toward the top', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = await createLoadedSettingsCubit();
    int? fromIndex;
    int? toIndex;

    await pumpAzkarSliver(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: CustomAzkarFormItemsSection(
          items: _items(),
          isBuiltIn: false,
          topInset: 0,
          onEdit: (_) {},
          onDelete: (_) {},
          onReorder: (from, to) {
            fromIndex = from;
            toIndex = to;
          },
        ),
      ),
    );

    final state = tester.state<ScrollableState>(find.byType(Scrollable));
    state.position.jumpTo(1000);
    await tester.pump();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text(_longText).at(2)),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    await gesture.moveTo(const Offset(200, 20));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(state.position.pixels, lessThan(1000));

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(toIndex, isNotNull);
    expect(toIndex, lessThan(fromIndex!));
  });

  testWidgets('drag proxy stays below the pinned app bar', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = await createLoadedSettingsCubit();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              const CommonSliverAppBar(title: 'title', isPinned: true),
              BlocProvider<AzkarTasbeehSettingsCubit>.value(
                value: cubit,
                child: CustomAzkarFormItemsSection(
                  items: _items(),
                  isBuiltIn: false,
                  topInset: kToolbarHeight,
                  onEdit: (_) {},
                  onDelete: (_) {},
                  onReorder: (_, _) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text(_longText).first),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    await gesture.moveTo(const Offset(200, 0));
    await tester.pump(const Duration(milliseconds: 200));

    final proxy = find.byType(ZikrReorderCard).last;
    expect(tester.getTopLeft(proxy).dy, greaterThanOrEqualTo(kToolbarHeight));

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  });
}
