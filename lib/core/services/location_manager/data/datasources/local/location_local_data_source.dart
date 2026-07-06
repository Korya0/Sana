import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/services/location_manager/data/datasources/local/geolocator_wrapper.dart';
import 'package:sana/core/utils/utils.dart';

abstract class ILocationLocalDataSource {
  Future<bool> isLocationEnabled();
  Future<bool> hasPermission();
  Future<LocationPermission> checkPermissionStatus();
  Future<LocationPermission> requestPermission();
  Future<bool> openLocationSettings();
  Future<Position> getCurrentPosition();
  Future<Position?> getLastKnownPosition();
  Future<String?> getCityAndCountryNative(
    double lat,
    double lng,
    String locale,
  );
}

class LocationLocalDataSource implements ILocationLocalDataSource {
  LocationLocalDataSource(this._geolocator);

  final IGeolocatorWrapper _geolocator;

  @override
  Future<bool> isLocationEnabled() async {
    return _geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> hasPermission() async {
    final status = await _geolocator.checkPermissionStatus();
    return status == LocationPermission.whileInUse ||
        status == LocationPermission.always;
  }

  @override
  Future<LocationPermission> checkPermissionStatus() async {
    return _geolocator.checkPermissionStatus();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return _geolocator.requestPermission();
  }

  @override
  Future<bool> openLocationSettings() async {
    if (kIsWeb) return false;
    return _geolocator.openLocationSettings();
  }

  @override
  Future<Position> getCurrentPosition() async {
    return _geolocator
        .getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(
              seconds: 5,
            ),
          ),
        )
        .timeout(const Duration(seconds: 5));
  }

  @override
  Future<Position?> getLastKnownPosition() async {
    if (kIsWeb) return null;
    return _geolocator.getLastKnownPosition();
  }

  @override
  Future<String?> getCityAndCountryNative(
    double lat,
    double lng,
    String locale,
  ) async {
    try {
      await geocoding.setLocaleIdentifier(locale);
      for (var i = 0; i < 2; i++) {
        try {
          final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
          if (placemarks.isEmpty) return null;

          final place = placemarks.first;
          final part1 =
              place.locality ??
              place.subAdministrativeArea ??
              place.administrativeArea;
          final part2 = place.country;

          if (part1 != null && part2 != null) {
            return '$part1, $part2';
          } else if (part2 != null) {
            return part2;
          } else {
            return null;
          }
        } on PlatformException catch (e) {
          final isIOError = e.code == 'IO_ERROR' || e.code == 'network_error';
          if (isIOError && i == 0) {
            await Future<void>.delayed(const Duration(seconds: 1));
            continue;
          }
          rethrow;
        }
      }
      return null;
    } on Exception catch (e, stack) {
      if (e is PlatformException &&
          (e.code == 'IO_ERROR' || e.code == 'network_error')) {
        unawaited(AppLogger.warn('Transient geocoding error: $e'));
      } else {
        unawaited(
          AppLogger.reportToFirebase(
            'GetCityAndCountry Native Error',
            error: e,
            stackTrace: stack,
          ),
        );
      }
      return null;
    }
  }
}
