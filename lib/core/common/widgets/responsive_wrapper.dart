import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

/// A widget responsible for making the app UI responsive on web.
/// It constraints the app width to the center to mimic a mobile screen layout on wide screens.
class ResponsiveWrapper extends StatelessWidget {

  const ResponsiveWrapper({required this.child, super.key});
  final Widget child;

  // Constants for easy future adjustments
  static const double kWebBreakpoint = 600;
  static const double kMaxMobileWidth = 500;

  @override
  Widget build(BuildContext context) {
    // If the app is not running on web, return the child without any modifications
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isWideScreen = screenWidth > kWebBreakpoint;

        return ColoredBox(
          // External background visible only on wide screens
          color: isWideScreen
              ? AppColors.secondaryBackground
              : Colors.transparent,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Limit the maximum width of the app to maintain the mobile look
                maxWidth: isWideScreen ? kMaxMobileWidth : screenWidth,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  // Add a soft shadow to give a floating effect on web
                  boxShadow: isWideScreen
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: MediaQuery(
                  // Update MediaQuery data to match the actual container size
                  data: MediaQuery.of(context).copyWith(
                    size: Size(
                      isWideScreen ? kMaxMobileWidth : screenWidth,
                      constraints.maxHeight,
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
