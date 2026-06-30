import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/services/location_manager/data/repos/i_location_repository.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.repository}) : super(const LocationInitial()) {
    _init();
  }

  void _init() {
    try {
      if (repository.hasStoredLocation()) {
        emit(
          const LocationSuccess(
            message: AppStrings.locationStoredCheckSuccess,
          ),
        );
      }
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'LocationCubit Init Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  final ILocationRepository repository;
  int _deniedCount = 0;

  Future<void> checkLocationStatus() async {
    if (repository.hasStoredLocation()) {
      await _updateLocationSilently();
    } else {
      await enforceLocation();
    }
  }

  bool hasStoredLocation() => repository.hasStoredLocation();
  String? getStoredLocationName() => repository.getStoredLocationName();

  bool _isEnforcing = false;

  void requestChoice() {
    if (!isClosed) {
      emit(const LocationShowChoiceSheet());
    }
  }

  void skipLocation() {
    if (!isClosed) {
      emit(const LocationSkipped());
    }
  }

  Future<void> enforceLocation() async {
    if (_isEnforcing) return;
    _isEnforcing = true;
    if (!isClosed) emit(const LocationLoading());

    // التحقق من تفعيل خدمة الموقع
    final isEnabledResult = await repository.isLocationEnabled();
    final isEnabled = switch (isEnabledResult) {
      Success(:final data) => data,
      FailureResult() => false,
    };

    if (!isEnabled) {
      if (!isClosed) emit(const LocationNeedsServiceEnable());
      _isEnforcing = false;
      return;
    }

    // التحقق من إذن الوصول للموقع
    final hasPermissionResult = await repository.hasPermission();
    final hasPermission = switch (hasPermissionResult) {
      Success(:final data) => data,
      FailureResult() => false,
    };

    if (!hasPermission) {
      final statusResult = await repository.getPermissionStatus();
      final status = switch (statusResult) {
        Success(:final data) => data,
        FailureResult() => LocationPermission.denied,
      };

      if (status == LocationPermission.deniedForever) {
        if (!isClosed) emit(const LocationPermissionPermanentlyDenied());
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
      emit(
        const LocationSuccess(
          message: AppStrings.locationStoredCheckSuccess,
        ),
      );
    }
    // تم إلغاء التحديث التلقائي في الخلفية بناءً على طلب المستخدم
  }

  /// فتح إعدادات الموقع
  Future<void> enableLocationService() async {
    final result = await repository.openLocationSettings();
    switch (result) {
      case Success():
        break;
      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
  }

  /// طلب إذن الوصول
  Future<void> requestLocationPermission() async {
    final result = await repository.requestPermission();

    switch (result) {
      case Success(:final data):
        final perm = data;
        if (perm == LocationPermission.deniedForever) {
          if (!isClosed) {
            emit(const LocationPermissionPermanentlyDenied());
          }
          return;
        }

        if (perm == LocationPermission.denied) {
          _deniedCount++;
          if (_deniedCount >= 2) {
            if (!isClosed) {
              emit(const LocationPermissionPermanentlyDenied());
            }
          } else {
            if (!isClosed) {
              emit(const LocationNeedsPermission());
            }
          }
          return;
        }

        // إذا وصلنا هنا، فالإذن ممنوح (whileInUse أو always)
        _deniedCount = 0;
        await _savePosition();

      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
  }

  Future<void> _savePosition() async {
    if (!isClosed) emit(const LocationLoading());
    final result = await repository.saveCurrentPosition();

    switch (result) {
      case Success():
        emit(const LocationSuccess(message: AppStrings.locationSavedSuccess));
      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
    _isEnforcing = false;
  }

  Future<void> saveManualLocation({
    required double lat,
    required double lng,
    required String name,
  }) async {
    if (!isClosed) emit(const LocationLoading());
    final result = await repository.saveManualPosition(
      lat: lat,
      lng: lng,
      name: name,
    );

    switch (result) {
      case Success():
        emit(const LocationSuccess(message: AppStrings.locationSavedSuccess));
      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
    _isEnforcing = false;
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
