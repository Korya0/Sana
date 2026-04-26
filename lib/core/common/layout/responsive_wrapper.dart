import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({required this.child, super.key});
  final Widget child;

  static const double kWebBreakpoint = 600;
  static const double kMaxMobileWidth = 500;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isWideScreen = screenWidth > kWebBreakpoint;

        return ColoredBox(
          color: isWideScreen
              ? AppColors.secondaryBackground
              : Colors.transparent,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? kMaxMobileWidth : screenWidth,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
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
