
import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_empty_view.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:solar_icons/solar_icons.dart';

class NoFavoriteYet extends StatelessWidget {
  const NoFavoriteYet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AppEmptyView(
      message: AppStrings.noFavoritesYet,
      icon: SolarIconsOutline.heart,
    );
  }
}