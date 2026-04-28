import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/networking/api_clients/location_api_client.dart';
import 'package:sana/core/services/location_manager/data/constants/location_api_constants.dart';
import 'package:sana/core/utils/app_logger.dart';

abstract class ILocationRemoteDataSource {
  Future<String> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  });
}

class LocationRemoteDataSourceImpl implements ILocationRemoteDataSource {
  LocationRemoteDataSourceImpl(this._locationApiClient);

  final LocationApiClient _locationApiClient;

  @override
  Future<String> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  }) async {
    try {
      if (kIsWeb) {
        // [Web Support] استخدام Nominatim API بدلاً من مكتبة geocoding غير المدعومة في الويب
        return _getCityAndCountryWeb(lat, lng, locale);
      }

      await setLocaleIdentifier(locale);

      // Retry mechanism for transient errors (max 2 attempts)
      for (var i = 0; i < 2; i++) {
        try {
          final placemarks = await placemarkFromCoordinates(lat, lng);
          if (placemarks.isEmpty) return AppStrings.unknownLocation;

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
            return AppStrings.unknownLocation;
          }
        } on PlatformException catch (e) {
          final isIOError = e.code == 'IO_ERROR' || e.code == 'network_error';
          if (isIOError && i == 0) {
            // Wait slightly before retry
            await Future<void>.delayed(const Duration(seconds: 1));
            continue;
          }
          rethrow;
        }
      }
      return AppStrings.unknownLocation;
    } on Exception catch (e, stack) {
      final errorStr = e.toString().toUpperCase();
      final isTransient =
          (e is PlatformException &&
              (e.code == 'IO_ERROR' || e.code == 'network_error')) ||
          errorStr.contains('IO_ERROR') ||
          errorStr.contains('NETWORK_ERROR') ||
          errorStr.contains('UNAVAILABLE');

      if (isTransient) {
        // Log locally only to avoid flooding Crashlytics
        AppLogger.warn('Transient geocoding error: $e');
      } else {
        unawaited(
          AppLogger.error(
            'GetCityAndCountry Non-Web Error',
            error: e,
            stackTrace: stack,
          ),
        );
      }
      return AppStrings.unknownLocation;
    }
  }

  Future<String> _getCityAndCountryWeb(
    double lat,
    double lng,
    String locale,
  ) async {
    try {
      final response = await _locationApiClient.getCityAndCountryWeb(
        lat,
        lng,
        locale,
        LocationApiConstants.searchFormatJsonv2,
      );

      final address = response.address;

      if (address != null) {
        final city = address.effectiveCity;
        final country = address.country;

        if (city != null && country != null) {
          return '$city, $country';
        } else if (country != null) {
          return country;
        }
      }
      return AppStrings.unknownLocation;
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('Error in Web Geocoding', error: e, stackTrace: stack),
      );
      return AppStrings.unknownLocation;
    }
  }
}
