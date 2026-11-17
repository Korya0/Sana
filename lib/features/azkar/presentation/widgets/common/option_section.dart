import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';

class OptionSection extends StatelessWidget {
  const OptionSection({
    required this.title,
    required this.children,
    super.key,
    this.leading,
  });

  final String title;
  final List<Widget> children;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header
      Padding(
        padding: EdgeInsetsDirectional.only(
          start: AppSize.p4,
          bottom: AppSize.p8,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              AppGap.w(AppSize.p4),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.font14W700Secondary(context),
              ),
            ),
          ],
        ),
      ),

      // Body
      ...children,
    ],
  );
}
