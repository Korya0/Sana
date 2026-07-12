import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_item_card.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockAzkarCubit extends Mock implements AzkarCubit {}
class MockReadingSettingsCubit extends Mock implements ReadingSettingsCubit {}

void main() {
  late MockAzkarCubit mockCubit;
  late MockReadingSettingsCubit mockReadingSettingsCubit;
  late ZikrEntity testZikr;

  setUp(() {
    registerTestServices();
    final haptic = sl<IHapticService>();
    when(haptic.playVibrate).thenAnswer((_) async {});
    when(haptic.playDoubleVibrate).thenAnswer((_) async {});

    mockCubit = MockAzkarCubit();
    mockReadingSettingsCubit = MockReadingSettingsCubit();
    when(() => mockReadingSettingsCubit.state).thenReturn(const ReadingSettingsInitial());
    when(() => mockReadingSettingsCubit.stream).thenAnswer((_) => Stream.value(const ReadingSettingsInitial()));
    testZikr = const ZikrEntity(
      id: 1,
      text: 'Test Zikr Text',
      count: 3,
      description: 'Test description',
    );
  });

  tearDown(sl.reset);

  Future<void> pumpCard(
    WidgetTester tester, {
    ZikrEntity? zikr,
    AzkarState? state,
    void Function(int)? onCompleted,
    VoidCallback? onShare,
    VoidCallback? onCopy,
  }) async {
    final effectiveZikr = zikr ?? testZikr;
    final effectiveState =
        state ??
        AzkarLoaded(
          azkar: [effectiveZikr],
          counters: {effectiveZikr.id: 0},
          resolvedTitle: 'الأذكار',
        );

    when(() => mockCubit.state).thenReturn(effectiveState);
    when(() => mockCubit.stream).thenAnswer(
      (_) => Stream<AzkarState>.value(effectiveState),
    );
    when(() => mockCubit.incrementZikr(any())).thenReturn(
      const ZikrIncremented(),
    );

    setTestScreenSize(tester);
    await tester.pumpWidget(
      createTestApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<AzkarCubit>.value(value: mockCubit),
            BlocProvider<ReadingSettingsCubit>.value(value: mockReadingSettingsCubit),
          ],
          child: ZikrItemCard(
            zikr: effectiveZikr,
            index: 0,
            onCompleted: onCompleted != null ? () => onCompleted(0) : null,
            onSharePressed: onShare,
            onCopyPressed: onCopy,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ZikrItemCard', () {
    testWidgets('renders zikr text and description', (tester) async {
      await pumpCard(tester);

      expect(find.text('Test Zikr Text'), findsOneWidget);
      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('shows remaining count in counter', (tester) async {
      const zikr = ZikrEntity(id: 1, text: 'Z', count: 3);
      const state = AzkarLoaded(azkar: [zikr], counters: {1: 0}, resolvedTitle: 'الأذكار');

      await pumpCard(tester, zikr: zikr, state: state);

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('handles missing description without crashing', (tester) async {
      const zikr = ZikrEntity(id: 2, text: 'No desc zikr', count: 1);

      await pumpCard(
        tester,
        zikr: zikr,
        state: const AzkarLoaded(azkar: [zikr], counters: {2: 0}, resolvedTitle: 'الأذكار'),
      );

      expect(find.text('No desc zikr'), findsOneWidget);
      expect(find.textContaining('description'), findsNothing);
    });

    testWidgets('shows check icon in counter when completed', (tester) async {
      const zikr = ZikrEntity(id: 1, text: 'Completed Zikr', count: 1);
      const state = AzkarLoaded(azkar: [zikr], counters: {1: 1}, resolvedTitle: 'الأذكار');

      await pumpCard(tester, zikr: zikr, state: state);

      expect(find.text('Completed Zikr'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('calls incrementZikr on tap', (tester) async {
      const zikr = ZikrEntity(id: 1, text: 'Tap Zikr', count: 1);
      const initialState = AzkarLoaded(azkar: [zikr], counters: {1: 0}, resolvedTitle: 'الأذكار');

      when(() => mockCubit.incrementZikr(1)).thenReturn(
        const ZikrCompleted(),
      );

      await pumpCard(tester, zikr: zikr, state: initialState);

      await tester.tap(find.byType(ZikrItemCard));
      await tester.pumpAndSettle();

      verify(() => mockCubit.incrementZikr(1)).called(1);
    });

    testWidgets('calls incrementZikr with ZikrCompleted result', (
      tester,
    ) async {
      const zikr = ZikrEntity(id: 1, text: 'Max Zikr', count: 1);
      const initialState = AzkarLoaded(azkar: [zikr], counters: {1: 0}, resolvedTitle: 'الأذكار');

      when(() => mockCubit.incrementZikr(1)).thenReturn(
        const ZikrCompleted(),
      );

      await pumpCard(tester, zikr: zikr, state: initialState);

      await tester.tap(find.byType(ZikrItemCard));
      await tester.pumpAndSettle();

      verify(() => mockCubit.incrementZikr(1)).called(1);
    });

    testWidgets('ignores tap when already completed', (tester) async {
      const zikr = ZikrEntity(id: 1, text: 'Done Zikr', count: 1);
      const completedState = AzkarLoaded(azkar: [zikr], counters: {1: 1}, resolvedTitle: 'الأذكار');

      await pumpCard(tester, zikr: zikr, state: completedState);

      await tester.tap(find.byType(ZikrItemCard));
      await tester.pumpAndSettle();

      verifyNever(() => mockCubit.incrementZikr(any()));
    });

    testWidgets('share button triggers onShare callback', (tester) async {
      const zikr = ZikrEntity(id: 1, text: 'Share Zikr', count: 3);
      const state = AzkarLoaded(azkar: [zikr], counters: {1: 0}, resolvedTitle: 'الأذكار');

      var shareTapped = false;

      await pumpCard(
        tester,
        zikr: zikr,
        state: state,
        onShare: () => shareTapped = true,
      );

      expect(find.byType(CombinedShareCopyButton), findsOneWidget);

      await tester.tap(find.byType(CombinedShareCopyButton));
      await tester.pumpAndSettle();

      expect(shareTapped, isTrue);
    });

    testWidgets(
      'renders share icon when both share and copy callbacks provided',
      (tester) async {
        const zikr = ZikrEntity(id: 1, text: 'Icon Zikr', count: 3);
        const state = AzkarLoaded(azkar: [zikr], counters: {1: 0}, resolvedTitle: 'الأذكار');

        await pumpCard(
          tester,
          zikr: zikr,
          state: state,
          onShare: () {},
          onCopy: () {},
        );

        expect(find.byIcon(SolarIconsOutline.share), findsOneWidget);
      },
    );
  });
}
