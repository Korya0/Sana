import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/features/location_manager/data/repositories/location_repository.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.repository}) : super(LocationInitial());
  final ILocationRepository repository;
  int _deniedCount = 0;

  Future<void> checkLocationStatus() async {
    if (repository.hasStoredLocation()) {
      await _updateLocationSilently();
    } else {
      await enforceLocation();
    }
  }

  bool _isEnforcing = false;

  Future<void> enforceLocation() async {
    if (_isEnforcing) return;
    _isEnforcing = true;
    if (!isClosed) emit(LocationLoading());

    // التحقق من تفعيل خدمة الموقع
    final isEnabledResult = await repository.isLocationEnabled();
    final isEnabled = isEnabledResult.fold((_) => false, (val) => val);

    if (!isEnabled) {
      if (!isClosed) emit(const LocationNeedsServiceEnable());
      _isEnforcing = false;
      return;
    }

    // التحقق من إذن الوصول للموقع
    final hasPermissionResult = await repository.hasPermission();
    final hasPermission = hasPermissionResult.fold((_) => false, (val) => val);

    if (!hasPermission) {
      // زيادة عدد المحاولات
      _deniedCount++;
      if (_deniedCount >= 2) {
        if (!isClosed) emit(LocationPermissionPermanentlyDenied());
      } else {
        if (!isClosed) emit(const LocationNeedsPermission());
      }
      _isEnforcing = false;
      return;
    }

    // حفظ الموقع الحالي
    await _savePosition();
  }

  Future<void> _updateLocationSilently() async {
    // إذا كان لدينا موقع مخزن، نرسل نجاح فوراً لكي يدخل المستخدم للتطبيق
    if (!isClosed) {
      emit(const LocationSuccess(message: 'تم التحقق من الموقع المخزن'));
    }

    // نتحقق في الخلفية إذا كان بإمكاننا تحديث الموقع
    final isEnabledResult = await repository.isLocationEnabled();
    if (isEnabledResult.isLeft()) return;

    final hasPermissionResult = await repository.hasPermission();
    if (hasPermissionResult.isLeft()) return;

    // تحديث الموقع في الخلفية
    await repository.saveCurrentPosition();
  }

  /// فتح إعدادات الموقع
  Future<void> enableLocationService() async {
    final result = await repository.openLocationSettings();
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (_) => null,
    );
  }

  /// طلب إذن الوصول
  Future<void> requestLocationPermission() async {
    final result = await repository.requestPermission();

    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (perm) async {
        if (perm == LocationPermission.deniedForever) {
          if (!isClosed) emit(LocationPermissionPermanentlyDenied());
          return;
        }

        if (perm == LocationPermission.denied) {
          _deniedCount++;
          if (_deniedCount >= 2) {
            if (!isClosed) emit(LocationPermissionPermanentlyDenied());
          } else {
            if (!isClosed) emit(const LocationNeedsPermission());
          }
          return;
        }

        // إذا وصلنا هنا، فالإذن ممنوح (whileInUse أو always)
        _deniedCount = 0;
        await _savePosition();
      },
    );
  }

  Future<void> _savePosition() async {
    if (!isClosed) emit(LocationLoading());
    final result = await repository.saveCurrentPosition();

    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (_) => emit(const LocationSuccess(message: 'تم حفظ موقعك بنجاح')),
    );
    _isEnforcing = false;
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
