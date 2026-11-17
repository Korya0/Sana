import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_card_shell.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_counter.dart';

class ZikrFormItemTile extends StatelessWidget {
  const ZikrFormItemTile({
    required this.zikr,
    required this.onEdit,
    this.onDelete,
    super.key,
  });

  final ZikrEntity zikr;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => ZikrCardShell(
    showBadge: zikr.canBeDeleted,
    content: BlocBuilder<
      AzkarTasbeehSettingsCubit,
      AzkarTasbeehSettingsState
    >(
      builder: (context, state) => ReadingTextContent(
        text: zikr.text,
        subText: zikr.description,
        fontSize: state.settingsOrDefault.fontSize,
      ),
    ),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              color: context.color.errorText,
              tooltip: AppStrings.deleteZikr,
              onPressed: onDelete,
            ),
          ],
        ),
        Semantics(
          label: AppStrings.remainingCounterLabel,
          value: '${zikr.count}',
          excludeSemantics: true,
          child: ZikrCounter(completedCount: 0, totalCount: zikr.count),
        ),
      ],
    ),
  );
}
