import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/features/location_manager/data/location_repo.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.locationRepo}) : super(LocationInitial());
  final LocationRepo locationRepo;
  int _deniedCount = 0;

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
    if (!isClosed) emit(LocationLoading());

    try {
      // التحقق من تفعيل خدمة الموقع
      final isLocationEnabled = await locationRepo.isLocationEnabled();
      if (!isLocationEnabled) {
        if (!isClosed) emit(LocationNeedsServiceEnable());
        _isEnforcing = false;
        return;
      }

      // التحقق من إذن الوصول للموقع
      final hasPermission = await locationRepo.hasPermission();

      if (!hasPermission) {
        // زيادة عدد المحاولات
        _deniedCount++;
        if (_deniedCount >= 2) {
          if (!isClosed) emit(LocationPermissionPermanentlyDenied());
        } else {
          if (!isClosed) emit(LocationNeedsPermission());
        }
        _isEnforcing = false;
        return;
      }

      // حفظ الموقع الحالي
      await _savePosition();
    } on Exception catch (e) {
      _isEnforcing = false;
      emit(LocationError(message: 'حدث خطأ غير متوقع: $e'));
    }
  }

  Future<void> _updateLocationSilently() async {
    // إذا كان لدينا موقع مخزن، نرسل نجاح فوراً لكي يدخل المستخدم للتطبيق
    if (!isClosed) emit(LocationSuccess(message: 'تم التحقق من الموقع المخزن'));

    try {
      // نتحقق في الخلفية إذا كان بإمكاننا تحديث الموقع
      final isLocationEnabled = await locationRepo.isLocationEnabled();
      if (!isLocationEnabled) return;

      final hasPermission = await locationRepo.hasPermission();
      if (!hasPermission) return;

      // تحديث الموقع في الخلفية
      await locationRepo.saveCurrentPosition();
    } on FormatException catch (_) {}
  }

  /// فتح إعدادات الموقع
  Future<void> enableLocationService() async {
    try {
      await locationRepo.openLocationSettings();
    } on Exception catch (e) {
      emit(
        LocationError(message: 'خطأ في فتح إعدادات الموقع: $e'),
      );
    }
  }

  /// طلب إذن الوصول
  Future<void> requestLocationPermission() async {
    try {
      final perm = await locationRepo.requestPermission();

      if (perm == LocationPermission.deniedForever) {
        if (!isClosed) emit(LocationPermissionPermanentlyDenied());
        return;
      }

      if (perm == LocationPermission.denied) {
        _deniedCount++;
        if (_deniedCount >= 2) {
          if (!isClosed) emit(LocationPermissionPermanentlyDenied());
        } else {
          if (!isClosed) emit(LocationNeedsPermission());
        }
        return;
      }

      // إذا وصلنا هنا، فالإذن ممنوح (whileInUse أو always)
      // إعادة ضبط العداد عند نجاح الإذن
      _deniedCount = 0;
      await _savePosition();
    } on Exception catch (e) {
      emit(LocationError(message: 'خطأ في طلب الإذن: $e'));
    }
  }

  Future<void> _savePosition() async {
    emit(LocationLoading());
    try {
      final result = await locationRepo.saveCurrentPosition();

      result.fold(
        (failure) {
          if (!isClosed) {
            emit(
              LocationError(message: 'فشل حفظ الموقع: $failure'),
            );
          }
        },
        (_) {
          if (!isClosed) emit(LocationSuccess(message: 'تم حفظ موقعك بنجاح'));
        },
      );
    } on Exception catch (e) {
      emit(LocationError(message: 'خطأ في حفظ الموقع: $e'));
    } finally {
      _isEnforcing = false;
    }
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
