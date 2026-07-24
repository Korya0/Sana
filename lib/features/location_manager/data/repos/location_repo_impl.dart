import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/features/location_manager/data/data_sources/local/location_local_data_source.dart';
import 'package:sana/features/location_manager/data/data_sources/remote/location_remote_data_source.dart';
import 'package:sana/features/location_manager/data/repos/location_repository.dart';
import 'package:sana/core/utils/utils.dart';

class LocationRepoImpl implements LocationRepository {
  LocationRepoImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.sharedPref,
  });

  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;
  final LocalStorageService sharedPref;

  AppLocationPermission _mapPermission(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.denied => AppLocationPermission.denied,
      LocationPermission.deniedForever => AppLocationPermission.deniedForever,
      LocationPermission.whileInUse => AppLocationPermission.whileInUse,
      LocationPermission.always => AppLocationPermission.always,
      LocationPermission.unableToDetermine =>
        AppLocationPermission.unableToDetermine,
    };
  }

  @override
  Future<Result<bool>> isLocationEnabled() async {
    try {
      final isEnabled = await localDataSource.isLocationEnabled();
      return Result.success(isEnabled);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn('IsLocationEnabled Error', error: e, stackTrace: stack),
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
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn(
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
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn('HasPermission Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationPermissionCheckError),
      );
    }
  }

  @override
  Future<Result<AppLocationPermission>> requestPermission() async {
    try {
      final permission = await localDataSource.requestPermission();
      return Result.success(_mapPermission(permission));
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn('RequestPermission Error', error: e, stackTrace: stack),
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

      await Future.wait([
        sharedPref.setDouble(StorageKeys.latitude, position.latitude),
        sharedPref.setDouble(StorageKeys.longitude, position.longitude),
        sharedPref.remove(StorageKeys.locationName),
      ]);
      return const Result.success(true);
    } on Object catch (e, stack) {
      if (e is PermissionDeniedException ||
          e is LocationServiceDisabledException) {
        unawaited(AppLogger.warn('Location Permission/Service failure: $e'));
      } else if (e is TimeoutException) {
        unawaited(AppLogger.warn('Location request timed out'));
        return const Result.failure(
          LocationFailure(
            message: AppStrings.gpsTimeoutError,
          ),
        );
      } else {
        unawaited(
          AppLogger.reportToFirebase(
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
      await Future.wait([
        sharedPref.setDouble(StorageKeys.latitude, lat),
        sharedPref.setDouble(StorageKeys.longitude, lng),
        sharedPref.setString(StorageKeys.locationName, name),
      ]);
      return const Result.success(null);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn(
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
      if (kIsWeb) {
        final name = await remoteDataSource.getCityAndCountry(
          lat: lat,
          lng: lng,
          locale: locale,
        );
        return Result.success(name);
      } else {
        final nativeName = await localDataSource.getCityAndCountryNative(
          lat,
          lng,
          locale,
        );
        if (nativeName != null && nativeName.isNotEmpty) {
          return Result.success(nativeName);
        }
        // Fallback to web geocoding if native fails/fails to find
        final webName = await remoteDataSource.getCityAndCountry(
          lat: lat,
          lng: lng,
          locale: locale,
        );
        return Result.success(webName);
      }
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'GetCityAndCountry Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.locationNameFetchError),
      );
    }
  }

  @override
  Future<Result<AppLocationPermission>> getPermissionStatus() async {
    try {
      final status = await localDataSource.checkPermissionStatus();
      return Result.success(_mapPermission(status));
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn(
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
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.warn(
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
