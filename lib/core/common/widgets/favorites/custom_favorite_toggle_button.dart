import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomFavoriteToggleButton extends StatelessWidget {
  const CustomFavoriteToggleButton({
    required this.onPressed,
    required this.isFav,
    super.key,
  });

  final bool isFav;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        onPressed();
        AppToast.show(
          context,
          isFav ? AppStrings.removedFromFavorites : AppStrings.addedToFavorites,
        );
      },
      icon: Icon(
        isFav ? SolarIconsBold.heart : SolarIconsOutline.heart,
        color: AppColors.gold,
        size: 20,
      ),
    );
  }
}
