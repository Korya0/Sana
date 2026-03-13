import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/location_manager/data/repositories/location_repository.dart';

part 'location_cubit.freezed.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.repository})
    : super(const LocationState.initial());
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
    if (!isClosed) emit(const LocationState.loading());

    // التحقق من تفعيل خدمة الموقع
    final isEnabledResult = await repository.isLocationEnabled();
    final isEnabled = isEnabledResult.when(
      success: (val) => val,
      failure: (_) => false,
    );

    if (!isEnabled) {
      if (!isClosed) emit(const LocationState.needsServiceEnable());
      _isEnforcing = false;
      return;
    }

    // التحقق من إذن الوصول للموقع
    final hasPermissionResult = await repository.hasPermission();
    final hasPermission = hasPermissionResult.when(
      success: (val) => val,
      failure: (_) => false,
    );

    if (!hasPermission) {
      // زيادة عدد المحاولات
      _deniedCount++;
      if (_deniedCount >= 2) {
        if (!isClosed) emit(const LocationState.permissionPermanentlyDenied());
      } else {
        if (!isClosed) emit(const LocationState.needsPermission());
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
      emit(
        const LocationState.success(
          message: AppStrings.locationStoredCheckSuccess,
        ),
      );
    }

    // نتحقق في الخلفية إذا كان بإمكاننا تحديث الموقع
    final isEnabledResult = await repository.isLocationEnabled();
    final isEnabled = isEnabledResult.when(
      success: (val) => val,
      failure: (_) => false,
    );
    if (!isEnabled) return;

    final hasPermissionResult = await repository.hasPermission();
    final hasPermission = hasPermissionResult.when(
      success: (val) => val,
      failure: (_) => false,
    );
    if (!hasPermission) return;

    // تحديث الموقع في الخلفية
    await repository.saveCurrentPosition();
  }

  /// فتح إعدادات الموقع
  Future<void> enableLocationService() async {
    final result = await repository.openLocationSettings();
    result.when(
      success: (_) => null,
      failure: (failure) => emit(LocationState.error(message: failure.message)),
    );
  }

  /// طلب إذن الوصول
  Future<void> requestLocationPermission() async {
    final result = await repository.requestPermission();

    result.when(
      success: (perm) async {
        if (perm == LocationPermission.deniedForever) {
          if (!isClosed) {
            emit(const LocationState.permissionPermanentlyDenied());
          }
          return;
        }

        if (perm == LocationPermission.denied) {
          _deniedCount++;
          if (_deniedCount >= 2) {
            if (!isClosed) {
              emit(const LocationState.permissionPermanentlyDenied());
            }
          } else {
            if (!isClosed) {
              emit(const LocationState.needsPermission());
            }
          }
          return;
        }

        // إذا وصلنا هنا، فالإذن ممنوح (whileInUse أو always)
        _deniedCount = 0;
        await _savePosition();
      },
      failure: (failure) => emit(LocationState.error(message: failure.message)),
    );
  }

  Future<void> _savePosition() async {
    if (!isClosed) emit(const LocationState.loading());
    final result = await repository.saveCurrentPosition();

    result.when(
      success: (_) => emit(
        const LocationState.success(message: AppStrings.locationSavedSuccess),
      ),
      failure: (failure) => emit(LocationState.error(message: failure.message)),
    );
    _isEnforcing = false;
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
