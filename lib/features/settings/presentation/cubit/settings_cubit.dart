import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/settings/presentation/cubit/settings_state.dart';

/// كيوبيت الإعدادات.
/// يقوم بإدارة منطق العمل وتجهيز البيانات اللازمة لواجهة المستخدم،
/// مثل تحديد صلاحية التقييم على المنصة الحالية ونصوص المشاركة
/// دون تسريب أي فحص مباشر للمنصة (kIsWeb) إلى طبقة العرض.
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
