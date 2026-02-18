import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithSearchSliverAppBar extends StatelessWidget {
  final bool isSearchVisible;
  final bool autoFocus;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;
  final Function(String) onSearchChanged;

  const HadithSearchSliverAppBar({
    super.key,
    required this.isSearchVisible,
    this.autoFocus = true,
    required this.searchController,
    required this.onToggleSearch,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CommonSliverAppBar(
      title: !isSearchVisible ? 'الأحاديث' : null,
      actions: [
        if (!isSearchVisible)
          IconButton(
            icon: const Icon(
              SolarIconsOutline.magnifier,
              color: AppColors.gold,
            ),
            onPressed: onToggleSearch,
          ),
        IconButton(
          icon: const Icon(SolarIconsBold.heart, color: AppColors.gold),
          onPressed: () => context.pushNamed(AppRoutes.hadithFavorites),
        ),
      ],
      titleWidget: isSearchVisible
          ? TextField(
              controller: searchController,
              autofocus: autoFocus,
              style: AppTextStyles.font16W500White(context),
              onChanged: onSearchChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[ء-ي\s]')),
              ],
              decoration: InputDecoration(
                hintText: 'ابحث عن حديث (حروف عربية فقط)...',
                hintStyle: AppTextStyles.font14W400Grey(context),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onToggleSearch,
                ),
              ),
            )
          : null,
    );
  }
}
