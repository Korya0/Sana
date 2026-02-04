// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class WebResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const WebResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        // تفعيل التصميم المحدد إذا كان العرض أكبر من 600 بكسل (مثل الكمبيوتر أو التابلت بالعرض)
        final bool isWideScreen = screenWidth > 600;

        return Container(
          // لون خلفية المتصفح الخارجية في حالة الشاشات العريضة
          color: isWideScreen
              ? AppColors.secondaryBackground
              : AppColors.scaffoldBackground,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // تحديد أقصى عرض للتطبيق بـ 500 بكسل فقط على الشاشات الكبيرة
                maxWidth: isWideScreen ? 500 : screenWidth,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  boxShadow: isWideScreen
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: MediaQuery(
                  // هنا نقوم بتعديل بيانات الـ MediaQuery لتطابق حجم الحاوية (500 بكسل) وليس حجم المتصفح
                  data: MediaQuery.of(context).copyWith(
                    size: Size(
                      isWideScreen ? 500 : screenWidth,
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
