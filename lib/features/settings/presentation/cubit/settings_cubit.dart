import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/settings/presentation/cubit/settings_state.dart';

/// كيوبيت الإعدادات.
/// يدير البيانات المحلية لشاشة الإعدادات فقط:
/// - تحديد صلاحية التقييم على المنصة الحالية
/// - نص المشاركة
/// إعدادات التطبيق العامة (المظهر / إبقاء الشاشة) تُدار عبر AppCubit.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            isRatingSupported: !kIsWeb,
            shareText: kIsWeb
                ? AppStrings.shareWebAppText(AppLinks.webApp)
                : AppStrings.shareAppText(AppLinks.storeLink),
          ),
        );
}
