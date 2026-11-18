import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_section.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows font size and haptics and opens the font size screen', (
    tester,
  ) async {
    final cubit = await createLoadedSettingsCubit();
    var fontSizeTaps = 0;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: ReadingSettingsSection(onFontSizeTap: () => fontSizeTaps++),
      ),
    );

    expect(find.text(AppStrings.azkarTasbeehSettingsTitle), findsOneWidget);
    expect(find.text(AppStrings.fontSize), findsOneWidget);
    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);

    await tester.tap(find.text(AppStrings.fontSize));
    await tester.pumpAndSettle();
    expect(fontSizeTaps, 1);
  });
}
