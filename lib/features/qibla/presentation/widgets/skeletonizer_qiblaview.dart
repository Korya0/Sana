import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/custom_arrow_back_button.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_hint_message.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_header_info.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solar_icons/solar_icons.dart';

class SkeletonizerQiblaview extends StatelessWidget {
  const SkeletonizerQiblaview({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.scaffoldBackground,
              elevation: 0,
              scrolledUnderElevation: 0,
              floating: true,
              snap: true,
              leading: const CustomArrowBackButton(),
              title: Text(
                AppStrings.qiblaDirection,
                style: AppTextStyles.font18W700White(context),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.v8,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      SolarIconsBold.questionCircle,
                      color: AppColors.iconWhite,
                    ),
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.v20),

                  // Header Info
                  const QiblaInfo(distance: 1377, direction: 138),

                  const SizedBox(height: AppSpacing.v20),

                  // Calibration Hint
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.v20,
                    ),
                    child: Text(
                      AppStrings.qiblaCalibrationHint,
                      style: AppTextStyles.font16W500Grey(
                        context,
                      ).copyWith(height: 1.5, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.v20),

                  // Compass placeholder
                  const Expanded(
                    child: Center(
                      child: SizedBox(height: 300, width: 300),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.v20),

                  // Hint Message
                  const QiblaHintMessage(angleDifference: 12),

                  const SizedBox(height: AppSpacing.v40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
