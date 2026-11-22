import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class ZakatSectionTitle extends StatelessWidget {
  const ZakatSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSize.p8,
        bottom: AppSize.p12,
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Container(
              width: AppSize.w4,
              height: AppSize.h18,
              decoration: BoxDecoration(
                color: context.color.borderBrand,
                borderRadius: BorderRadius.circular(AppSize.r4),
              ),
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                text,
                style: AppTextStyles.font19W700Brand(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
