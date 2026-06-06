import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/presentation/app_info_share.dart';
import 'package:sana/core/services/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

class AsmaUlHusnaShareCard extends StatelessWidget {
  const AsmaUlHusnaShareCard({required this.name, super.key});
  final AsmaulHusnaModel name;

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: customAppCardDecoration(context).copyWith(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -10.r(context),
              bottom: -20.r(context),
              child: Icon(
                FlutterIslamicIcons.solidAllah,
                size: 150.r(context),
                color: context.color.textPrimary.withValues(alpha: 0.05),
              ),
            ),
            Positioned(
              left: -30.r(context),
              top: -30.r(context),
              child: Icon(
                FlutterIslamicIcons.solidAllah,
                size: 200.r(context),
                color: context.color.textPrimary.withValues(alpha: 0.03),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.v24.r(context),
                vertical: AppSpacing.v48.r(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.r(context),
                        height: 40.r(context),
                        decoration: BoxDecoration(
                          color: context.color.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.color.primary.withValues(alpha: 0.5),
                            width: 1.5.r(context),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${name.id}',
                          style: AppTextStyles.font16W700(context).copyWith(color: context.color.textPrimary),
                        ),
                      ),
                      SizedBox(width: AppSpacing.v16.r(context)),
                      Text(
                        name.name,
                        style: AppTextStyles.fontQuran34W400primary(context),
                      ),
                      SizedBox(width: AppSpacing.v16.r(context)),
                      Expanded(
                        child: Text(
                          name.meaningBrief,
                          style: AppTextStyles.font16W500(context).copyWith(color: context.color.textAccent),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.v24.r(context)),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.r(context),
                          color: context.color.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.v12.r(context),
                        ),
                        child: Icon(
                          FlutterIslamicIcons.solidIftar,
                          color: context.color.primary,
                          size: 18.r(context),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.r(context),
                          color: context.color.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.v24.r(context)),

                  Text(
                    name.meaningDetailed,
                    style: AppTextStyles.font16W500(context).copyWith(color: context.color.textSecondary).copyWith(
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.v48.r(context)),

                  const AppInfoShare(
                    department: AppStrings.asmaUlHusnaShareCardDepartment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


