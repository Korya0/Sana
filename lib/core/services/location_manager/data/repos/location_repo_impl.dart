import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/location_manager/data/datasources/local/location_local_data_source.dart';
import 'package:sana/core/services/location_manager/data/repos/i_location_repository.dart';
import 'package:sana/core/services/location_manager/data/datasources/remote/location_remote_data_source.dart';
import 'package:sana/core/utils/utils.dart';

class LocationRepoImpl implements ILocationRepository {
  LocationRepoImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.sharedPref,
  });

  final ILocationLocalDataSource localDataSource;
  final ILocationRemoteDataSource remoteDataSource;
  final ILocalStorageService sharedPref;

  @override
  Future<Result<bool>> isLocationEnabled() async {
    try {
      final isEnabled = await localDataSource.isLocationEnabled();
      return Result.success(isEnabled);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('IsLocationEnabled Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationEnabledCheckError),
      );
    }
  }

  @override
  Future<Result<void>> openLocationSettings() async {
    try {
      await localDataSource.openLocationSettings();
      return const Result.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'OpenLocationSettings Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.openLocationSettingsError),
      );
    }
  }

  @override
  Future<Result<bool>> hasPermission() async {
    try {
      final permission = await localDataSource.hasPermission();
      return Result.success(permission);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('HasPermission Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationPermissionCheckError),
      );
    }
  }

  @override
  Future<Result<LocationPermission>> requestPermission() async {
    try {
      final permission = await localDataSource.requestPermission();
      return Result.success(permission);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('RequestPermission Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationPermissionRequestError),
      );
    }
  }

  @override
  Future<Result<bool>> saveCurrentPosition() async {
    try {
      final position = await localDataSource.getCurrentPosition();

      await sharedPref.setDouble(StorageKeys.latitude, position.latitude);
      await sharedPref.setDouble(StorageKeys.longitude, position.longitude);
      await sharedPref.remove(StorageKeys.locationName);
      return const Result.success(true);
    } on Exception catch (e, stack) {
      if (e is PermissionDeniedException ||
          e is LocationServiceDisabledException) {
        AppLogger.warn('Location Permission/Service failure: $e');
      } else if (e is TimeoutException) {
        AppLogger.warn('Location request timed out');
        return const Result.failure(
          LocationFailure(
            message: AppStrings
                .locationError, // Or specific timeout message if available, using general error for now
          ),
        );
      } else {
        unawaited(
          AppLogger.error(
            'SaveCurrentPosition Unexpected Error',
            error: e,
            stackTrace: stack,
          ),
        );
      }
      return const Result.failure(
        LocationFailure(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  Future<Result<void>> saveManualPosition({
    required double lat,
    required double lng,
    required String name,
  }) async {
    try {
      await sharedPref.setDouble(StorageKeys.latitude, lat);
      await sharedPref.setDouble(StorageKeys.longitude, lng);
      await sharedPref.setString(StorageKeys.locationName, name);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'SaveManualPosition Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        LocationFailure(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  Future<Result<String>> getCityAndCountry({
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
      return Result.success(name);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetCityAndCountry Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationNameFetchError),
      );
    }
  }

  @override
  Future<Result<LocationPermission>> getPermissionStatus() async {
    try {
      final status = await localDataSource.checkPermissionStatus();
      return Result.success(status);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'GetPermissionStatus Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationPermissionCheckError),
      );
    }
  }

  @override
  bool hasStoredLocation() {
    try {
      return sharedPref.getDouble(StorageKeys.latitude) != null &&
          sharedPref.getDouble(StorageKeys.longitude) != null;
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error checking stored location',
          error: e,
          stackTrace: stack,
        ),
      );
      return false;
    }
  }

  @override
  String? getStoredLocationName() {
    return sharedPref.getString(StorageKeys.locationName);
  }
}
