import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/font_size_section.dart';

class AzkarTasbeehSettingsBottomSheet extends StatelessWidget {
  const AzkarTasbeehSettingsBottomSheet({
    required this.cubit,
    super.key,
    this.showBackButton = false,
  });

  final AzkarTasbeehSettingsCubit cubit;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: cubit,
    child: BlocListener<AzkarTasbeehSettingsCubit, AzkarTasbeehSettingsState>(
      listenWhen: (previous, current) =>
          previous is! AzkarTasbeehSettingsError &&
          current is AzkarTasbeehSettingsError,
      listener: (context, state) {
        if (state is AzkarTasbeehSettingsError) {
          AppToast.show(context, state.message, type: AppToastType.error);
        }
      },
      child: AzkarOptionsSheetScaffold(
        title: AppStrings.fontSize,
        isNested: showBackButton,
        onDismiss: () => context.popOnce(showBackButton ? true : null),
        children: const [
          FontSizeSection(),
        ],
      ),
    ),
  );
}
