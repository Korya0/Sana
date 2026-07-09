import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/views/reading_settings/font_size_section.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockReadingSettingsCubit extends Mock implements ReadingSettingsCubit {}

void main() {
  late MockReadingSettingsCubit mockCubit;

  setUp(() {
    mockCubit = MockReadingSettingsCubit();
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestWidget() {
    return BlocProvider<ReadingSettingsCubit>.value(
      value: mockCubit,
      child: createTestApp(
        const Scaffold(
          body: FontSizeSection(),
        ),
      ),
    );
  }

  group('FontSizeSection Widget Tests', () {
    testWidgets('should display default font size when state is Initial',
        (tester) async {
      // arrange
      when(() => mockCubit.state).thenReturn(const ReadingSettingsInitial());
      setTestScreenSize(tester);

      // act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // assert
      expect(find.text(AppStrings.fontSizeTitle), findsOneWidget);
      expect(
        find.text('${AzkarConstants.defaultFontSize.toInt()}'),
        findsOneWidget,
      );
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('should display loaded font size when state is Loaded',
        (tester) async {
      // arrange
      const loadedSize = 26.0;
      when(() => mockCubit.state).thenReturn(
        const ReadingSettingsLoaded(ReadingSettings(fontSize: loadedSize)),
      );
      setTestScreenSize(tester);

      // act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('${loadedSize.toInt()}'), findsOneWidget);
      
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, loadedSize);
    });

    testWidgets('should call changeFontSize and saveSettings when Slider is dragged and released',
        (tester) async {
      // arrange
      const loadedSize = 20.0;
      when(() => mockCubit.state).thenReturn(
        const ReadingSettingsLoaded(ReadingSettings(fontSize: loadedSize)),
      );
      when(() => mockCubit.changeFontSize(any())).thenReturn(null);
      when(() => mockCubit.saveSettings()).thenAnswer((_) async {});
      setTestScreenSize(tester);

      // act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final sliderFinder = find.byType(Slider);
      
      // Tap near the center of the slider to change its value
      await tester.tap(sliderFinder);
      await tester.pumpAndSettle();

      // assert
      verify(() => mockCubit.changeFontSize(any())).called(greaterThan(0));
      verify(() => mockCubit.saveSettings()).called(greaterThan(0));
    });
  });
}
