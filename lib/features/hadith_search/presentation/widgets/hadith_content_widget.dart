import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class HadithContentWidget extends StatelessWidget {
  final String htmlContent;
  final bool isCentered;
  final double? baseFontSize;
  final int? maxLines;
  final bool isSharing;

  const HadithContentWidget({
    super.key,
    required this.htmlContent,
    this.isCentered = false,
    this.baseFontSize,
    this.maxLines,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    final double lineHeight = (baseFontSize ?? 18) * 1.6;
    final double? maxHeight = maxLines != null
        ? (maxLines! * lineHeight) + 100
        : null; // +100 for info rows

    final Widget htmlWidget = HtmlWidget(
      htmlContent,
      textStyle: AppTextStyles.font16W500White(
        context,
      ).copyWith(height: 1.6, fontSize: baseFontSize),
      customStylesBuilder: (element) {
        final align = isCentered ? 'center' : 'right';

        // تنسيق نص الحديث الأساسي
        if (element.classes.contains('hadith-body')) {
          return {
            'font-size': isCentered ? '22px' : '18px',
            'font-weight': 'bold',
            'margin-bottom': '12px',
            'color': '#ffffff',
            'text-align': align,
            if (isSharing) ...{
              'max-lines': '8',
              'text-overflow': 'ellipsis',
            } else if (maxLines != null) ...{
              'max-lines': '$maxLines',
              'text-overflow': 'ellipsis',
            },
          };
        }

        // إخفاء العناصر غير المرغوبة عند المشاركة (المصدر والفاصل) لضغط المساحة
        if (isSharing) {
          if (element.classes.contains('divider')) {
            return {'display': 'none'};
          }
          if (element.classes.contains('info-row') &&
              element.text.contains('المصدر:')) {
            return {'display': 'none'};
          }
        }

        if (element.classes.contains('highlight') ||
            element.classes.contains('search-keys')) {
          if (isSharing) {
            return null; // الغاء التلوين في حال المشاركة ليبقى النص أبيض
          }
          return {
            'color': '#D4AF37',
            'background-color': 'rgba(212, 175, 55, 0.1)',
            'font-weight': 'bold',
            'padding': '0 2px',
          };
        }

        if (element.classes.contains('divider')) {
          return {
            'height': '1px',
            'background-color': 'rgba(255, 255, 255, 0.1)',
            'margin': '10px 0',
          };
        }

        if (element.classes.contains('info-row')) {
          return {
            'font-size': isCentered ? '14px' : '13px',
            'color': '#ffffff',
            'margin-bottom': '4px',
            'text-align': align,
          };
        }

        if (element.classes.contains('lbl')) {
          return {'color': '#81868c'};
        }

        if (element.classes.contains('judgment-row')) {
          return {'text-align': align, 'margin-top': '8px'};
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

    if (maxLines != null) {
      return Container(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // ignore: deprecated_member_use
              colors: [Colors.white, Colors.white.withOpacity(0.0)],
              stops: const [0.8, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: htmlWidget,
        ),
      );
    }

    return htmlWidget;
  }
}
