/// [CustomRichContentDialog]
/// - الوظيفة الأساسية: نافذة لعرض المحتوى الكامل (نصوص طويلة) مثل الأحاديث، السنن، أدعية الصلاة والمناسبات الدينية.
/// - مميزاتها: تحتوي على أيقونة شفافة كبيرة كخلفية (Watermark Icon)، أزرار تفاعلية (نسخ، مشاركة)، وتعرض مصدر الحديث أو المحتوى إن وُجد.
/// - الاستخدام:
///   * بطاقات الويدجت الافتتاحية للصلاة (Carousel Cards الخاصة بفضل كل صلاة والمناسبات).
///   * بطاقات المحتوى اليومي (أحاديث يومية، سنن، شاشات المحتوى المفضل).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/sharing/logic/widget_to_image.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomRichContentDialog extends StatefulWidget {
  const CustomRichContentDialog({
    required this.bodyText,
    required this.backgroundIcon,
    this.title,
    this.source,
    this.showShareButton = false,
    this.shareWidgetToCapture,
    this.shareImageName,
    super.key,
  });

  final String bodyText;
  final String? title;
  final String? source;
  final IconData backgroundIcon;
  final bool showShareButton;
  final Widget? shareWidgetToCapture;
  final String? shareImageName;

  static void show(
    BuildContext context, {
    required String bodyText,
    required IconData backgroundIcon,
    String? title,
    String? source,
    bool showShareButton = false,
    Widget? shareWidgetToCapture,
    String? shareImageName,
  }) {
    unawaited(
      showDialog(
        context: context,
        builder: (context) => CustomRichContentDialog(
          bodyText: bodyText,
          backgroundIcon: backgroundIcon,
          title: title,
          source: source,
          showShareButton: showShareButton,
          shareWidgetToCapture: shareWidgetToCapture,
          shareImageName: shareImageName,
        ),
      ),
    );
  }

  @override
  State<CustomRichContentDialog> createState() =>
      _CustomRichContentDialogState();
}

class _CustomRichContentDialogState extends State<CustomRichContentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Content Card
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: customAppCardDecoration(),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -20,
                    child: Icon(
                      widget.backgroundIcon,
                      size: 150,
                      color: AppColors.iconWhite.withValues(alpha: 0.05),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.v24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null &&
                            widget.title!.isNotEmpty) ...[
                          Text(
                            widget.title!,
                            style: AppTextStyles.font22W700primary(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.v16),
                        ],

                        // Body
                        Text(
                          widget.bodyText,
                          style: AppTextStyles.font20W700White(context)
                              .copyWith(
                                height: 1.6,
                              ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),

                        if (widget.source != null &&
                            widget.source!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.v24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.v12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusS,
                              ),
                            ),
                            child: Text(
                              widget.source!,
                              style: AppTextStyles.font14W400primary(context)
                                  .copyWith(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.v32),

                        // Bottom Actions Row
                        _buildActions(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Right Side: Empty placeholder to keep center aligned
        if (widget.showShareButton)
          const SizedBox(
            width: AppSpacing.v48,
          ) // Roughly the size of the share button
        else
          const SizedBox.shrink(),

        // Center: Close Button
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.v16,
              vertical: AppSpacing.v8,
            ),
            backgroundColor: AppColors.primary.withValues(
              alpha: 0.1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                SolarIconsOutline.closeCircle,
                color: AppColors.iconPrimary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.v8),
              Text(
                AppStrings.close,
                style: AppTextStyles.font14W600primary(context),
              ),
            ],
          ),
        ),

        // Left Side: Share Button
        if (widget.showShareButton)
          CombinedShareCopyButton(
            onSharePressed: widget.shareWidgetToCapture != null
                ? () async => WidgetToImage.shareWidget(
                    context: context,
                    widget: widget.shareWidgetToCapture!,
                    imageName: widget.shareImageName ?? 'shared_content',
                  )
                : () async {},
            onCopyPressed: () async {
              final text =
                  '${widget.title ?? ""}\n${widget.bodyText}\n${widget.source ?? ""}';
              await Clipboard.setData(
                ClipboardData(text: text.trim()),
              );
            },
            iconSize: 20,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
