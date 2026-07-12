import 'package:sana/core/common/common.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';

class DailyContentExplanationDialog extends StatelessWidget {
  const DailyContentExplanationDialog({
    required this.explanation,
    super.key,
  });

  final String explanation;

  static const double _bulletSize = 6;

  @override
  Widget build(BuildContext context) {
    final instructions = explanation
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return CustomDialog(
      padding: const EdgeInsets.all(AppSpacing.v20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Text(
              AppStrings.explanationAndClarification,
              style: AppTextStyles.font20W700(
                context,
              ).copyWith(color: context.color.textPrimary),
            ),
          ),

          const AppGap.h(AppSpacing.v24),

          // Content
          Flexible(
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: instructions
                      .map(
                        (instruction) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.v12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: AppSpacing.v8,
                                ),
                                width: _bulletSize,
                                height: _bulletSize,
                                decoration: BoxDecoration(
                                  color: context.color.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const AppGap.w(AppSpacing.v12),
                              Expanded(
                                child: Text(
                                  instruction.trim(),
                                  style: AppTextStyles.font14W500(context)
                                      .copyWith(
                                        color: context.color.textPrimary,
                                        height: 1.6,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          const AppGap.h(AppSpacing.v20),

          // Footer Action
          SizedBox(
            width: double.infinity,
            child: AppSecondaryButton(
              onPressed: () => context.pop(),
              text: AppStrings.iUnderstood,
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String explanation,
    String? routeName,
  }) {
    unawaited(
      showDialog<void>(
        context: context,
        routeSettings: routeName != null
            ? RouteSettings(name: routeName)
            : null,
        builder: (context) => DailyContentExplanationDialog(
          explanation: explanation,
        ),
      ),
    );
  }
}
