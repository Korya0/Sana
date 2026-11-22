import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import '../zakat_info_card.dart';

class HawlSection extends StatelessWidget {
  const HawlSection({
    super.key,
    required this.hawlCompleted,
    required this.hawlError,
    required this.onHawlChanged,
  });

  final bool hawlCompleted;
  final bool hawlError;
  final ValueChanged<bool?> onHawlChanged;

  @override
  Widget build(BuildContext context) {
    final showError = hawlError && !hawlCompleted;

    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              AppStrings.zakatHawlTitle,
              style: AppTextStyles.font16W700Primary(context),
            ),
            subtitle: Text(
              AppStrings.zakatHawlSubtitle,
              style: AppTextStyles.font14W400Relaxed(context),
            ),
            value: hawlCompleted,
            onChanged: onHawlChanged,
          ),
          if (showError) ...[
            AppGap.h(AppSize.p8),
            Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      AppIcons.error,
                      color: context.color.errorText,
                      size: AppSize.icon16,
                    ),
                  ),
                  AppGap.w(AppSize.p8),
                  Expanded(
                    child: Text(
                      AppStrings.zakatHawlError,
                      style: AppTextStyles.font14W700Error(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
