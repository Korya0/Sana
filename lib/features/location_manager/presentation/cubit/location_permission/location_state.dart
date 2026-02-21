abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {
  LocationSuccess({this.message = 'تم بنجاح'});
  final String message;
}

/// يطلب من المستخدم تفعيل خدمة الموقع (يعرض Dialog قبل الفتح)
class LocationNeedsServiceEnable extends LocationState {
  LocationNeedsServiceEnable({
    this.message = 'يرجى تفعيل خدمة الموقع للمتابعة',
  });
  final String message;
}

/// يطلب من المستخدم السماح بإذن الموقع (يعرض Dialog قبل الطلب)
class LocationNeedsPermission extends LocationState {
  LocationNeedsPermission({this.message = 'يرجى السماح بالوصول إلى موقعك'});
  final String message;
}

/// خدمة الموقع معطلة (بعد رفض المستخدم)
class LocationDisabled extends LocationState {
  LocationDisabled({this.message = 'خدمة الموقع معطلة'});
  final String message;
}

/// إذن الموقع مرفوضة (بعد رفض المستخدم)
class LocationPermissionDenied extends LocationState {
  LocationPermissionDenied({this.message = 'تم رفض إذن الموقع'});
  final String message;
}

/// خطأ عام
class LocationError extends LocationState {
  LocationError({required this.message});
  final String message;
}

class LocationPermissionPermanentlyDenied extends LocationState {}
