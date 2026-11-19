import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_section.dart';

enum AzkarHomeOption { fontSize, manageCustomAzkar }

class AzkarHomeOptionsBottomSheet extends StatelessWidget {
  const AzkarHomeOptionsBottomSheet({
    required this.azkarTasbeehSettingsCubit,
    super.key,
  });

  final AzkarTasbeehSettingsCubit azkarTasbeehSettingsCubit;

  @override
  Widget build(BuildContext context) {
    final closeButton = AppIconButton(
      icon: AppIcons.close,
      tooltip: AppStrings.close,
      onPressed: () => context.popOnce(),
    );

    return BlocProvider.value(
      value: azkarTasbeehSettingsCubit,
      child: AzkarOptionsSheetScaffold(
        children: [
          ReadingSettingsSection(
            leading: closeButton,
            onFontSizeTap: () => context.popOnce(AzkarHomeOption.fontSize),
          ),
          AppGap.h(AppSize.p16),
          OptionSection(
            title: AppStrings.customAzkar,
            children: [
              OptionTile(
                icon: AppIcons.adhkar,
                label: AppStrings.manageCustomAzkar,
                onPressed: () =>
                    context.popOnce(AzkarHomeOption.manageCustomAzkar),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
