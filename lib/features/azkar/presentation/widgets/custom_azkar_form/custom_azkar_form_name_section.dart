import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';

class CustomAzkarFormNameSection extends StatelessWidget {
  const CustomAzkarFormNameSection({
    required this.controller,
    required this.isLocked,
    super.key,
  });

  final TextEditingController controller;
  final bool isLocked;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: AppSize.shp,
    sliver: SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGap.h(AppSize.p8),
          AppTextField(
            controller: controller,
            label: AppStrings.azkarName,
            hint: AppStrings.azkarNameHint,
            isLocked: isLocked,
            trailing: isLocked
                ? Icon(
                    AppIcons.lock,
                    size: AppSize.icon16,
                    color: context.color.iconSecondary,
                  )
                : null,
            inputFormatters: AppValidators.arabicNameInputFormatters,
            validator: (v) =>
                AppValidators.requiredField(v, AppStrings.azkarNameRequired),
          ),
          AppGap.h(AppSize.p16),
        ],
      ),
    ),
  );
}
