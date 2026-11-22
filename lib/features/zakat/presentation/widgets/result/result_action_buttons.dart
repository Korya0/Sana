import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: AppStrings.zakatEditData,
          icon: AppIcons.edit,
          expand: true,
          onPressed: () => context.pop(),
        ),
        AppGap.h(AppSize.p12),
        AppButton(
          label: AppStrings.zakatBackHome,
          icon: AppIcons.home,
          expand: true,
          variant: AppButtonVariant.secondary,
          onPressed: () => context.go(AppRoutes.zakatHome),
        ),
      ],
    );
  }
}
