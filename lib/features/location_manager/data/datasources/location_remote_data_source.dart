import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sana/core/constants/api_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/core/utils/app_logger.dart';

class LocationRemoteDataSource {
  LocationRemoteDataSource(this._apiService);

  final ApiService _apiService;

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
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'GetCityAndCountry Non-Web Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return AppStrings.unknownLocation;
    }
  }

  /// [Web Support] جلب اسم المنطقة عبر طلب HTTP خارجي للويب
  Future<String> _getCityAndCountryWeb(
    double lat,
    double lng,
    String locale,
  ) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        ApiConstants.nominatimReverseUrl,
        queryParameters: {
          ApiConstants.queryParamFormat: ApiConstants.searchFormatJsonv2,
          ApiConstants.queryParamLat: lat,
          ApiConstants.queryParamLon: lng,
          ApiConstants.queryParamAcceptLanguage: locale,
        },
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          final address = data['address'] as Map<String, dynamic>;

          final city =
              address['city'] ??
              address['town'] ??
              address['village'] ??
              address['suburb'] ??
              address['state'];
          final country = address['country'];

          if (city != null && country != null) {
            return '$city, $country';
          } else if (country != null) {
            return country as String;
          }
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
