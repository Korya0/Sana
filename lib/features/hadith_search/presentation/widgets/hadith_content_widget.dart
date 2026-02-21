import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class HadithContentWidget extends StatelessWidget {

  const HadithContentWidget({
    required this.htmlContent, super.key,
    this.isCentered = false,
    this.baseFontSize,
    this.maxLines,
    this.isSharing = false,
  });
  final String htmlContent;
  final bool isCentered;
  final double? baseFontSize;
  final int? maxLines;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlContent,
      textStyle: AppTextStyles.font16W500White(
        context,
      ).copyWith(height: 1.6, fontSize: baseFontSize),
      customStylesBuilder: (element) {
        final align = isCentered ? 'center' : 'right';

        // 1. متن الحديث (8 أسطر في المشاركة)
        if (element.classes.contains('hadith-body')) {
          return {
            'font-size': isCentered ? '22px' : '18px',
            'font-weight': 'bold',
            'margin-bottom': '12px',
            'color': '#ffffff',
            'text-align': align,
            'max-lines': isSharing ? '8' : (maxLines?.toString() ?? 'none'),
            'text-overflow': (isSharing || maxLines != null)
                ? 'ellipsis'
                : 'none',
          };
        }

        // 2. بيانات الحديث (سطر واحد لكل معلومة في المشاركة لضمان عدم التعدي)
        if (element.classes.contains('info-row') ||
            element.classes.contains('judgment-row')) {
          // إخفاء المصدر عند المشاركة
          if (isSharing && element.text.contains('المصدر:')) {
            return {'display': 'none'};
          }

          return {
            'font-size': isCentered ? '14px' : '13px',
            'color': '#ffffff',
            'margin-bottom': '4px',
            'text-align': align,
            if (isSharing) ...{'max-lines': '1', 'text-overflow': 'ellipsis'},
          };
        }

        // إخفاء الفاصل عند المشاركة لتوفير مساحة
        if (isSharing && element.classes.contains('divider')) {
          return {'display': 'none'};
        }

        // تمييز الكلمات (إلغاء التلوين في المشاركة للمتن فقط)
        if (element.classes.contains('highlight') ||
            element.classes.contains('search-keys')) {
          if (isSharing) return null;
          return {
            'color': '#D4AF37',
            'background-color': 'rgba(212, 175, 55, 0.1)',
            'font-weight': 'bold',
            'padding': '0 2px',
          };
        }

        // بقية التنسيقات العادية
        if (element.classes.contains('divider')) {
          return {
            'height': '1px',
            'background-color': 'rgba(255, 255, 255, 0.1)',
            'margin': '10px 0',
          };
        }

        if (element.classes.contains('lbl')) {
          return {'color': '#81868c'};
        }

        if (element.classes.contains('judgment-label')) {
          return {
            'font-size': isCentered ? '15px' : '14px',
            'color': '#81868c',
          };
        }

        if (element.classes.contains('judgment-value')) {
          return {
            'font-size': isCentered ? '16px' : '15px',
            'font-weight': 'bold',
            'color': '#D4AF37',
          };
        }

        if (element.classes.contains('result')) {
          return {'color': '#D4AF37', 'font-weight': 'bold'};
        }

        return null;
      },
    );
  }
}
