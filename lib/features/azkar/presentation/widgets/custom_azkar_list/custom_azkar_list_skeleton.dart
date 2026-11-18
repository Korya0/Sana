import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_category_list_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomAzkarListSkeleton extends StatelessWidget {
  const CustomAzkarListSkeleton({super.key});

  static const _dummy = CustomCategoryEntity(
    id: 'skeleton',
    name: AppStrings.loading,
    azkar: [],
  );

  @override
  Widget build(BuildContext context) => Skeletonizer.sliver(
    child: SliverIgnorePointer(
      sliver: SliverPadding(
        padding: AppSize.shp,
        sliver: SliverMainAxisGroup(
          slivers: [
            AppSliverList(
              itemCount: AppConstants.azkarListSkeletonCount,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: AppSize.p12),
                child: CustomAzkarCategoryListTile(
                  category: _dummy,
                  isBuiltIn: false,
                  onEdit: () {},
                  onDelete: () {},
                  onRestore: () {},
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppGap.h(AppSize.p8),
                  AppPrimaryButton(
                    label: AppStrings.addCustomAzkar,
                    expand: true,
                    onPressed: () {},
                  ),
                  AppGap.h(AppSize.sbp),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
