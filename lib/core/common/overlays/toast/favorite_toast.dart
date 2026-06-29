import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/constants.dart';

class FavoriteToast {
  const FavoriteToast._();

  static void showFavoriteToast(BuildContext context, {required bool isAdded}) {
    AppToast.show(
      context,
      isAdded ? AppStrings.addedToFavorites : AppStrings.removedFromFavorites,
      type: isAdded ? AppToastType.success : AppToastType.info,
    );
  }
}
