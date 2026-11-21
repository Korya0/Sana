import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';

import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/card_action_menu.dart';
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
        CardActionMenu(
          showCountActions: false,
          canAdjust: false,
          onDecrement: () {},
          onReset: () {},
          onEdit: onEdit,
          onDelete: onDelete,
          editLabel: AppStrings.editZikr,
          deleteLabel: AppStrings.deleteZikr,
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
