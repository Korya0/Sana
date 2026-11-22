import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';

class LoadingPricesIndicator extends StatelessWidget {
  const LoadingPricesIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p16),
      child: Center(
        child: Semantics(
          label: AppStrings.zakatLoadingPrices,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSize.icon16,
                height: AppSize.icon16,
                child: CircularProgressIndicator(
                  strokeWidth: AppSize.borderWidth,
                ),
              ),
              AppGap.w(AppSize.p8),
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    AppStrings.zakatLoadingPrices,
                    style: AppTextStyles.font14W400Primary(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
