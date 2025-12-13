abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {
  final String message;
  LocationSuccess({this.message = 'تم بنجاح'});
}

/// يطلب من المستخدم تفعيل خدمة الموقع (يعرض Dialog قبل الفتح)
class LocationNeedsServiceEnable extends LocationState {
  final String message;
  LocationNeedsServiceEnable({
    this.message = 'يرجى تفعيل خدمة الموقع للمتابعة',
  });
}

/// يطلب من المستخدم السماح بإذن الموقع (يعرض Dialog قبل الطلب)
class LocationNeedsPermission extends LocationState {
  final String message;
  LocationNeedsPermission({this.message = 'يرجى السماح بالوصول إلى موقعك'});
}

/// خدمة الموقع معطلة (بعد رفض المستخدم)
class LocationDisabled extends LocationState {
  final String message;
  LocationDisabled({this.message = 'خدمة الموقع معطلة'});
}

/// إذن الموقع مرفوضة (بعد رفض المستخدم)
class LocationPermissionDenied extends LocationState {
  final String message;
  LocationPermissionDenied({this.message = 'تم رفض إذن الموقع'});
}

/// خطأ عام
class LocationError extends LocationState {
  final String message;
  LocationError({required this.message});
}

class LocationPermissionPermanentlyDenied extends LocationState {}
