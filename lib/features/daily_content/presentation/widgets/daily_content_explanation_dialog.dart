import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentExplanationDialog extends StatelessWidget {
  const DailyContentExplanationDialog({
    required this.explanation,
    super.key,
  });

  final String explanation;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'شرح وتوضيح',
                      style: AppTextStyles.font16W600Gold(context),
                    ),
                    Row(
                      children: [
                        // Copy Only Button
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: explanation),
                            ).then((_) {
                              if (context.mounted) {
                                AppToast.show(context, 'تم نسخ الشرح بنجاح');
                              }
                            });
                          },
                          icon: const Icon(
                            SolarIconsOutline.copy,
                            color: AppColors.gold,
                            size: 20,
                          ),
                          tooltip: 'نسخ الشرح',
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            SolarIconsOutline.closeCircle,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white12),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      explanation,
                      style: AppTextStyles.font16W500White(context).copyWith(
                        height: 1.6,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),

              // Footer Action
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: const Text(
                      'فهمت، جزاكم الله خيراً',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String explanation,
  }) {
    unawaited(
      showDialog<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => DailyContentExplanationDialog(
          explanation: explanation,
        ),
      ),
    );
  }
}
