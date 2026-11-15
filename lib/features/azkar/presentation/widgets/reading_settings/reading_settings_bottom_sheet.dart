import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/font_size_section.dart';

class ReadingSettingsBottomSheet extends StatelessWidget {
  // Creates sheet
  const ReadingSettingsBottomSheet({
    required this.cubit,
    super.key,
    this.showBackButton = false,
  });

  final ReadingSettingsCubit cubit;
  final bool showBackButton;

  // Builds sheet
  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: cubit,
    child: BlocListener<ReadingSettingsCubit, ReadingSettingsState>(
      listenWhen: (previous, current) =>
          previous is! ReadingSettingsError && current is ReadingSettingsError,
      listener: (context, state) {
        if (state is ReadingSettingsError) {
          AppToast.show(context, state.message, type: AppToastType.error);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p20,
          vertical: AppSize.p16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body
            FontSizeSection(showBackButton: showBackButton),
          ],
        ),
      ),
    ),
  );
}
