import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/custom_zikr_badge.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class CustomZikrFormItemTile extends StatelessWidget {
  // Creates tile
  const CustomZikrFormItemTile({
    required this.zikr,
    required this.onEdit,
    this.onDelete,
    super.key,
  });

  final ZikrEntity zikr;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  // Builds tile
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: AppSize.p16),
    child: Stack(
      children: [
        // Body
        AppSectionCard(
          padding: EdgeInsetsDirectional.fromSTEB(
            AppSize.p20,
            zikr.canBeDeleted ? AppSize.p20 + AppSize.p16 : AppSize.p20,
            AppSize.p20,
            AppSize.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Content
              BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
                builder: (context, state) {
                  final fontSize = switch (state) {
                    ReadingSettingsLoaded(:final settings) => settings.fontSize,
                    ReadingSettingsError(:final settings?) => settings.fontSize,
                    _ => ReadingSettingsEntity.defaultFontSize,
                  };
                  return ZikrContent(
                    text: zikr.text,
                    subText: zikr.description,
                    fontSize: fontSize,
                  );
                },
              ),
              AppGap.h(AppSize.p24),

              // Divider
              const CustomAppDivider(),
              AppGap.h(AppSize.p24),

              // Actions + counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIconButton(
                        icon: AppIcons.edit,
                        tooltip: AppStrings.editZikr,
                        onPressed: onEdit,
                      ),
                      AppGap.w(AppSize.p8),
                      AppIconButton(
                        icon: AppIcons.delete,
                        color: AppColorsCommon.errorColor,
                        tooltip: AppStrings.deleteZikr,
                        onPressed: onDelete,
                      ),
                    ],
                  ),

                  // Counter
                  Semantics(
                    label: AppStrings.remainingCounterLabel,
                    value: '${zikr.count}',
                    excludeSemantics: true,
                    child: ZikrCounter(
                      completedCount: 0,
                      totalCount: zikr.count,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Badge
        if (zikr.canBeDeleted)
          PositionedDirectional(
            top: AppSize.p8,
            end: AppSize.p8,
            child: const CustomZikrBadge(),
          ),
      ],
    ),
  );
}
