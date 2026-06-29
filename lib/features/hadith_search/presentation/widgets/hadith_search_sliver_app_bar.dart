import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/features/hadith_search/presentation/widgets/custom_search_icon_button.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_text_field.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithSearchSliverAppBar extends StatelessWidget {
  const HadithSearchSliverAppBar({
    required this.isSearchVisible,
    required this.searchController,
    required this.onToggleSearch,
    required this.onSearchChanged,
    super.key,
    this.autoFocus = true,
  });
  final bool isSearchVisible;
  final bool autoFocus;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return CommonSliverAppBar(
      title: !isSearchVisible ? AppStrings.hadiths : null,
      actions: [
        if (!isSearchVisible)
          CustomSearchIconButton(onToggleSearch: onToggleSearch),
        IconButton(
          icon: Icon(SolarIconsBold.heart, color: context.color.primary),
          onPressed: () {
            unawaited(playVibrate());
            unawaited(context.pushNamed(AppRoutes.hadithFavorites));
          },
        ),
      ],
      titleWidget: isSearchVisible
          ? HadithSearchTextField(
              searchController: searchController,
              onSearchChanged: onSearchChanged,
              onToggleSearch: onToggleSearch,
              autoFocus: autoFocus,
            )
          : null,
    );
  }
}
