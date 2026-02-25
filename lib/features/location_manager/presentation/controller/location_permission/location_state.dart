part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {
  const LocationSuccess({this.message = 'تم بنجاح'});
  final String message;

  @override
  List<Object?> get props => [message];
}

/// يطلب من المستخدم تفعيل خدمة الموقع (يعرض Dialog قبل الفتح)
class LocationNeedsServiceEnable extends LocationState {
  const LocationNeedsServiceEnable({
    this.message = 'يرجى تفعيل خدمة الموقع للمتابعة',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// يطلب من المستخدم السماح بإذن الموقع (يعرض Dialog قبل الطلب)
class LocationNeedsPermission extends LocationState {
  const LocationNeedsPermission({
    this.message = 'يرجى السماح بالوصول إلى موقعك',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// خدمة الموقع معطلة (بعد رفض المستخدم)
class LocationDisabled extends LocationState {
  const LocationDisabled({this.message = 'خدمة الموقع معطلة'});
  final String message;

  @override
  List<Object?> get props => [message];
}

/// إذن الموقع مرفوضة (بعد رفض المستخدم)
class LocationPermissionDenied extends LocationState {
  const LocationPermissionDenied({this.message = 'تم رفض إذن الموقع'});
  final String message;

  @override
  List<Object?> get props => [message];
}

/// خطأ عام
class LocationError extends LocationState {
  const LocationError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class LocationPermissionPermanentlyDenied extends LocationState {}
