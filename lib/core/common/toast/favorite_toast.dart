import 'package:flutter/material.dart';
import 'package:sana/core/common/toast/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';

class FavoriteToast {
  const FavoriteToast._();

  static void showFavoriteToast(BuildContext context, bool isAdded) {
    AppToast.show(
      context,
      isAdded ? AppStrings.addedToFavorites : AppStrings.removedFromFavorites,
      type: isAdded ? AppToastType.success : AppToastType.info,
    );
  }
}
