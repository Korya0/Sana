import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/reading_settings/font_size_section.dart';

class ReadingSettingsBottomSheet extends StatelessWidget {
  const ReadingSettingsBottomSheet({required this.cubit, super.key});

  final ReadingSettingsCubit cubit;

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: cubit,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p20,
        vertical: AppSize.p16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            AppStrings.readingSettingsTitle,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16W700Primary(context),
          ),
          AppGap.h(AppSize.p24),

          // Font size
          const FontSizeSection(),
        ],
      ),
    ),
  );
}
