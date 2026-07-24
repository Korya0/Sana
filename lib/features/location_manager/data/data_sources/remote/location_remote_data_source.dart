import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/location_manager/data/constants/location_api_constants.dart';
import 'package:sana/features/location_manager/data/data_sources/remote/location_api_client.dart';
import 'package:sana/core/utils/utils.dart';

abstract interface class LocationRemoteDataSource {
  Future<String> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  });
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl(this._locationApiClient);

  final LocationApiClient _locationApiClient;

  @override
  Future<String> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  }) async {
    try {
      final response = await _locationApiClient.getCityAndCountryWeb(
        lat,
        lng,
        locale,
        LocationApiConstants.searchFormatJsonv2,
      );

      if (response.address != null) {
        final address = response.address!;
        final city =
            address.city ??
            address.town ??
            address.village ??
            address.suburb ??
            address.state;
        final country = address.country;

        if (city != null && country != null) {
          return '$city, $country';
        } else if (country != null) {
          return country;
        }
      }
      return AppStrings.unknownLocation;
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error in Web Geocoding (Nominatim)',
          error: e,
          stackTrace: stack,
        ),
      );
      return AppStrings.unknownLocation;
    }
  }
}
