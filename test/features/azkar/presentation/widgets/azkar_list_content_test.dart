import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_list_content.dart';

class MockAzkarCubit extends MockCubit<AzkarState> implements AzkarCubit {}
class MockReadingSettingsCubit extends MockCubit<ReadingSettingsState>
    implements ReadingSettingsCubit {}

void main() {
  late MockAzkarCubit mockAzkarCubit;
  late MockReadingSettingsCubit mockSettingsCubit;

  setUp(() {
    mockAzkarCubit = MockAzkarCubit();
    mockSettingsCubit = MockReadingSettingsCubit();
  });

  Widget createTestWidget(AzkarState state) {
    when(() => mockAzkarCubit.state).thenReturn(state);
    when(() => mockSettingsCubit.state)
        .thenReturn(const ReadingSettingsInitial());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AzkarCubit>.value(value: mockAzkarCubit),
        BlocProvider<ReadingSettingsCubit>.value(value: mockSettingsCubit),
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(extensions: [MyColors.light]),
        home: const Scaffold(
          body: CustomScrollView(
            slivers: [AzkarListContent()],
          ),
        ),
      ),
    );
  }

  group('AzkarListContent', () {
    testWidgets('should show content when loading', (tester) async {
      await tester.pumpWidget(createTestWidget(AzkarLoading()));

      expect(find.byType(AzkarListContent), findsOneWidget);
    });

    testWidgets('should show error message on error', (tester) async {
      const errorState = AzkarError('خطأ في التحميل');
      await tester.pumpWidget(createTestWidget(errorState));

      expect(find.text('خطأ في التحميل'), findsOneWidget);
    });

    testWidgets('should show zikr text when loaded', (tester) async {
      const zikr = ZikrEntity(id: 1, text: 'سُبْحَانَ اللَّهِ', count: 3);
      const loadedState = AzkarLoaded(
        azkar: [zikr],
        counters: {1: 0},
        resolvedTitle: 'أذكار',
      );
      await tester.pumpWidget(createTestWidget(loadedState));

      expect(find.text('سُبْحَانَ اللَّهِ'), findsOneWidget);
    });

    testWidgets('should render without crashing for initial state', (tester) async {
      await tester.pumpWidget(createTestWidget(AzkarInitial()));

      // Verify the widget renders without throwing exceptions
      expect(tester.takeException(), isNull);
      expect(
        find.byType(AzkarListContent, skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
