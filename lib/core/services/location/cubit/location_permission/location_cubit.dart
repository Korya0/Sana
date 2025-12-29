import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_state.dart';
import 'package:sana/core/services/location/data/location_repo.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepo locationRepo;
  int _deniedCount = 0;

  LocationCubit({required this.locationRepo}) : super(LocationInitial());

  Future<void> checkLocationStatus() async {
    if (locationRepo.hasStoredLocation()) {
      await _updateLocationSilently();
    } else {
      await enforceLocation();
    }
  }

  bool _isEnforcing = false;

  Future<void> enforceLocation() async {
    if (_isEnforcing) return;
    _isEnforcing = true;
    emit(LocationLoading());

    try {
      // التحقق من تفعيل خدمة الموقع
      final isLocationEnabled = await locationRepo.isLocationEnabled();
      if (!isLocationEnabled) {
        emit(LocationNeedsServiceEnable());
        _isEnforcing = false;
        return;
      }

      // التحقق من إذن الوصول للموقع
      final bool hasPermission = await locationRepo.hasPermission();

      if (!hasPermission) {
        // زيادة عدد المحاولات
        _deniedCount++;
        if (_deniedCount >= 2) {
          emit(LocationPermissionPermanentlyDenied());
        } else {
          emit(LocationNeedsPermission());
        }
        _isEnforcing = false;
        return;
      }

      // حفظ الموقع الحالي
      await _savePosition();
    } catch (e) {
      _isEnforcing = false;
      emit(LocationError(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> _updateLocationSilently() async {
    // إذا كان لدينا موقع مخزن، نرسل نجاح فوراً لكي يدخل المستخدم للتطبيق
    emit(LocationSuccess(message: 'تم التحقق من الموقع المخزن'));

    try {
      // نتحقق في الخلفية إذا كان بإمكاننا تحديث الموقع
      final isLocationEnabled = await locationRepo.isLocationEnabled();
      if (!isLocationEnabled) return;

      final hasPermission = await locationRepo.hasPermission();
      if (!hasPermission) return;

      // تحديث الموقع في الخلفية
      await locationRepo.saveCurrentPosition();
      // ignore: empty_catches
    } catch (e) {}
  }

  /// فتح إعدادات الموقع
  Future<void> enableLocationService() async {
    try {
      await locationRepo.openLocationSettings();
    } catch (e) {
      emit(
        LocationError(message: 'خطأ في فتح إعدادات الموقع: ${e.toString()}'),
      );
    }
  }

  /// طلب إذن الوصول
  Future<void> requestLocationPermission() async {
    try {
      final perm = await locationRepo.requestPermission();

      if (perm == LocationPermission.deniedForever) {
        emit(LocationPermissionPermanentlyDenied());
        return;
      }

      final hasPermission = await locationRepo.hasPermission();
      if (!hasPermission) {
        _deniedCount++;
        if (_deniedCount >= 2) {
          emit(LocationPermissionPermanentlyDenied());
        } else {
          emit(LocationNeedsPermission());
        }
        return;
      }

      // إعادة ضبط العداد عند نجاح الإذن
      _deniedCount = 0;
      await _savePosition();
    } catch (e) {
      emit(LocationError(message: 'خطأ في طلب الإذن: ${e.toString()}'));
    }
  }

  Future<void> _savePosition() async {
    emit(LocationLoading());
    try {
      final result = await locationRepo.saveCurrentPosition();

      result.fold(
        (failure) => emit(
          LocationError(message: 'فشل حفظ الموقع: ${failure.toString()}'),
        ),
        (_) => emit(LocationSuccess(message: 'تم حفظ موقعك بنجاح')),
      );
    } catch (e) {
      emit(LocationError(message: 'خطأ في حفظ الموقع: ${e.toString()}'));
    } finally {
      _isEnforcing = false;
    }
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
