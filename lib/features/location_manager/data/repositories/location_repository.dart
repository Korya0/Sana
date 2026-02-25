import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/location_manager/data/datasources/location_local_data_source.dart';
import 'package:sana/features/location_manager/data/datasources/location_remote_data_source.dart';

abstract class ILocationRepository {
  /// تحقق إذا كان GPS مفعّل
  Future<Either<Failure, bool>> isLocationEnabled();

  /// طلب فتح إعدادات الـ GPS
  Future<Either<Failure, void>> openLocationSettings();

  /// تحقق من إذن الموقع
  Future<Either<Failure, bool>> hasPermission();

  /// طلب إذن الموقع
  Future<Either<Failure, LocationPermission>> requestPermission();

  /// جلب الموقع وحفظه في SharedPref
  Future<Either<Failure, bool>> saveCurrentPosition();

  /// جلب اسم المدينة والدولة
  Future<Either<Failure, String>> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  });

  /// التحقق من وجود موقع مخزن مسبقاً
  bool hasStoredLocation();
}

class LocationRepository implements ILocationRepository {
  LocationRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.sharedPref,
  });

  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;
  final SharedPref sharedPref;

  @override
  Future<Either<Failure, bool>> isLocationEnabled() async {
    try {
      final isEnabled = await localDataSource.isLocationEnabled();
      return Right(isEnabled);
    } catch (e) {
      return const Left(
        LocationFailure(message: 'تعذر التحقق من حالة الـ GPS'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> openLocationSettings() async {
    try {
      await localDataSource.openLocationSettings();
      return const Right(null);
    } catch (e) {
      return const Left(LocationFailure(message: 'تعذر فتح إعدادات الموقع'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasPermission() async {
    try {
      final permission = await localDataSource.hasPermission();
      return Right(permission);
    } catch (e) {
      return const Left(
        LocationFailure(message: 'تعذر التحقق من أذونات الموقع'),
      );
    }
  }

  @override
  Future<Either<Failure, LocationPermission>> requestPermission() async {
    try {
      final permission = await localDataSource.requestPermission();
      return Right(permission);
    } catch (e) {
      return const Left(LocationFailure(message: 'تعذر طلب إذن الموقع'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveCurrentPosition() async {
    try {
      final position = await localDataSource.getCurrentPosition();
      await sharedPref.setDouble(PrefKeys.latitude, position.latitude);
      await sharedPref.setDouble(PrefKeys.longitude, position.longitude);
      return const Right(true);
    } catch (e) {
      return Left(
        LocationFailure(
          message: AppStrings.locationError,
          technicalMessage: 'Geolocator Error: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  }) async {
    try {
      final name = await remoteDataSource.getCityAndCountry(
        lat: lat,
        lng: lng,
        locale: locale,
      );
      return Right(name);
    } catch (e) {
      return const Left(LocationFailure(message: 'تعذر جلب اسم المنطقة'));
    }
  }

  @override
  bool hasStoredLocation() {
    return sharedPref.getDouble(PrefKeys.latitude) != null &&
        sharedPref.getDouble(PrefKeys.longitude) != null;
  }
}
