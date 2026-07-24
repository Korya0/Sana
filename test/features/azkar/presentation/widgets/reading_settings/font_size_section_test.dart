import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/font_size_section.dart';

class MockReadingSettingsCubit extends MockCubit<ReadingSettingsState>
    implements ReadingSettingsCubit {}

void main() {
  late MockReadingSettingsCubit mockCubit;

  setUp(() {
    mockCubit = MockReadingSettingsCubit();
  });

  Widget createTestWidget(ReadingSettingsState state) {
    when(() => mockCubit.state).thenReturn(state);
    return BlocProvider<ReadingSettingsCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        theme: ThemeData().copyWith(extensions: [MyColors.light]),
        home: const Scaffold(body: FontSizeSection()),
      ),
    );
  }

  group('FontSizeSection', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const ReadingSettingsInitial(),
      ));

      expect(find.text('حجم الخط'), findsOneWidget);
    });

    testWidgets('should display current fontSize value', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const ReadingSettingsLoaded(ReadingSettings(fontSize: 16)),
      ));

      expect(find.text('16'), findsOneWidget);
    });

    testWidgets('should display Slider with min 12 and max 28', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const ReadingSettingsLoaded(ReadingSettings(fontSize: 20)),
      ));

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 12);
      expect(slider.max, 28);
    });

    testWidgets('should display labels for small and large', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const ReadingSettingsLoaded(ReadingSettings(fontSize: 20)),
      ));

      expect(find.text('صغير'), findsOneWidget);
      expect(find.text('كبير'), findsOneWidget);
    });

    testWidgets('should display preview text', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const ReadingSettingsLoaded(ReadingSettings(fontSize: 20)),
      ));

      expect(
        find.textContaining('اللَّهُمَّ بِكَ أَصْبَحْنَا'),
        findsOneWidget,
      );
    });
  });
}
