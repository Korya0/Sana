import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/extensions/assets_extension.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';

enum AppSizeClass { compact, medium, expanded, large }

extension ContextExtension on BuildContext {
  MyColors get color => Theme.of(this).extension<MyColors>()!;
  MyAssets get assets => Theme.of(this).extension<MyAssets>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // System UI
  Widget systemUiOverlay(Widget child) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      systemNavigationBarColor: AppColorsCommon.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ),
    child: child,
  );

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();

  // Text Scaling
  Widget preventTextScaling(Widget child) => MediaQuery(
    data: MediaQuery.of(this).copyWith(textScaler: const TextScaler.linear(1)),
    child: child,
  );

  AppSizeClass get sizeClass {
    final width = MediaQuery.sizeOf(this).width;
    if (width < AppSize.bpMobile) return AppSizeClass.compact;
    if (width < AppSize.bpTablet) return AppSizeClass.medium;
    if (width < AppSize.bpDesktop) return AppSizeClass.expanded;
    return AppSizeClass.large;
  }

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;
}
