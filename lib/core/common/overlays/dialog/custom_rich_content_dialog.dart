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
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                      color: AppColors.white.withValues(alpha: 0.05),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null &&
                            widget.title!.isNotEmpty) ...[
                          Text(
                            widget.title!,
                            style: AppTextStyles.font22W700Gold(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Body
                        Text(
                          widget.bodyText,
                          style: AppTextStyles.font20W700White(context)
                              .copyWith(
                                color: AppColors.white,
                                height: 1.6,
                              ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),

                        if (widget.source != null &&
                            widget.source!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.source!,
                              style: AppTextStyles.font14W400Gold(context)
                                  .copyWith(
                                    color: AppColors.gold.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),

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
          const SizedBox(width: 48) // Roughly the size of the share button
        else
          const SizedBox.shrink(),

        // Center: Close Button
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            backgroundColor: AppColors.gold.withValues(
              alpha: 0.1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                SolarIconsOutline.closeCircle,
                color: AppColors.gold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.close,
                style: AppTextStyles.font14W600Gold(context),
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
