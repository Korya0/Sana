import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart';

class MockAzkarCubit extends MockCubit<AzkarState> implements AzkarCubit {}
class MockReadingSettingsCubit extends MockCubit<ReadingSettingsState>
    implements ReadingSettingsCubit {}

Widget _buildApp(MultiBlocProvider providers) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ).copyWith(
      extensions: [MyColors.light],
    ),
    home: Scaffold(body: providers),
  );
}

void main() {
  late MockAzkarCubit mockAzkarCubit;
  late MockReadingSettingsCubit mockSettingsCubit;

  const zikr = ZikrEntity(id: 1, text: 'سُبْحَانَ اللَّهِ', count: 3);

  setUp(() {
    mockAzkarCubit = MockAzkarCubit();
    mockSettingsCubit = MockReadingSettingsCubit();
  });

  Widget createTestWidget(AzkarState state, {ReadingSettingsState? settingsState}) {
    when(() => mockAzkarCubit.state).thenReturn(state);
    when(() => mockSettingsCubit.state).thenReturn(
      settingsState ?? const ReadingSettingsInitial(),
    );

    return _buildApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AzkarCubit>.value(value: mockAzkarCubit),
          BlocProvider<ReadingSettingsCubit>.value(value: mockSettingsCubit),
        ],
        child: const ZikrItemCard(zikr: zikr, index: 0),
      ),
    );
  }

  group('ZikrItemCard', () {
    testWidgets('should display ZikrContent with text and description', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const AzkarLoaded(
          azkar: [zikr],
          counters: {1: 0},
          resolvedTitle: 'أذكار',
        ),
      ));

      expect(find.text('سُبْحَانَ اللَّهِ'), findsOneWidget);
    });

    testWidgets('should display ZikrItemCardContent', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const AzkarLoaded(
          azkar: [zikr],
          counters: {1: 0},
          resolvedTitle: 'أذكار',
        ),
      ));

      expect(find.byType(ZikrItemCardContent), findsOneWidget);
    });

    testWidgets('tapping should call incrementZikr', (tester) async {
      when(() => mockAzkarCubit.incrementZikr(1))
          .thenReturn(const ZikrIncremented());

      await tester.pumpWidget(createTestWidget(
        const AzkarLoaded(
          azkar: [zikr],
          counters: {1: 0},
          resolvedTitle: 'أذكار',
        ),
      ));

      await tester.tap(find.byType(ZikrItemCardContent));
      await tester.pump();

      verify(() => mockAzkarCubit.incrementZikr(1)).called(1);
    });

    testWidgets('should display content with AnimatedOpacity', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const AzkarLoaded(
          azkar: [zikr],
          counters: {1: 0},
          resolvedTitle: 'أذكار',
        ),
        settingsState: const ReadingSettingsLoaded(
          ReadingSettings(fontSize: 20),
        ),
      ));

      expect(find.byType(ZikrContent), findsOneWidget);
    });

    testWidgets('should use fontSize from ReadingSettingsCubit', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const AzkarLoaded(
          azkar: [zikr],
          counters: {1: 0},
          resolvedTitle: 'أذكار',
        ),
        settingsState: const ReadingSettingsLoaded(
          ReadingSettings(fontSize: 20),
        ),
      ));

      expect(find.byType(ZikrContent), findsOneWidget);
    });

    testWidgets('should render ZikrItemCard when loaded', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const AzkarLoaded(
          azkar: [zikr],
          counters: {1: 0},
          resolvedTitle: 'أذكار',
        ),
      ));

      expect(find.byType(ZikrItemCardContent), findsOneWidget);
    });
  });
}
