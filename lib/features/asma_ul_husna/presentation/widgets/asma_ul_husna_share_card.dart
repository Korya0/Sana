import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';

class AsmaUlHusnaShareCard extends StatelessWidget {
  const AsmaUlHusnaShareCard({required this.name, super.key});
  final AsmaUlHusnaEntity name;

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
            const Positioned.fill(
              child: _ShareCardBackgroundIcons(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.v24.r(context),
                vertical: AppSpacing.v24.r(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ShareCardHeader(name: name),
                  SizedBox(height: AppSpacing.v16.r(context)),
                  const _ShareCardDivider(),
                  SizedBox(height: AppSpacing.v16.r(context)),
                  Text(
                    name.meaningDetailed,
                    style: AppTextStyles.font16W500(context)
                        .copyWith(color: context.color.textPrimary)
                        .copyWith(
                          height: 1.7,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.v24.r(context)),
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

class _ShareCardHeader extends StatelessWidget {
  const _ShareCardHeader({required this.name});
  final AsmaUlHusnaEntity name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.w40.r(context),
          height: AppSpacing.h40.r(context),
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
            style: AppTextStyles.font16W700(
              context,
            ).copyWith(color: context.color.textPrimary),
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
            style: AppTextStyles.font16W500(
              context,
            ).copyWith(color: context.color.textAccent),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ShareCardBackgroundIcons extends StatelessWidget {
  const _ShareCardBackgroundIcons();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -10.r(context),
          bottom: -20.r(context),
          child: Icon(
            FlutterIslamicIcons.solidAllah,
            size: AppSpacing.s150.r(context),
            color: context.color.textPrimary.withValues(alpha: 0.05),
          ),
        ),
        Positioned(
          left: -30.r(context),
          top: -30.r(context),
          child: Icon(
            FlutterIslamicIcons.solidAllah,
            size: AppSpacing.s200.r(context),
            color: context.color.textPrimary.withValues(alpha: 0.03),
          ),
        ),
      ],
    );
  }
}

class _ShareCardDivider extends StatelessWidget {
  const _ShareCardDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            size: AppSpacing.s18.r(context),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.r(context),
            color: context.color.primary.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}
