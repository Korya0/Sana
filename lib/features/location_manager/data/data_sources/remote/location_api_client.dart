import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sana/features/location_manager/data/constants/location_api_constants.dart';
import 'package:sana/features/location_manager/data/models/nominatim_response_model.dart';

part 'location_api_client.g.dart';

@RestApi()
abstract class LocationApiClient {
  factory LocationApiClient(Dio dio, {String baseUrl}) = _LocationApiClient;

  @GET('reverse')
  Future<NominatimResponseModel> getCityAndCountryWeb(
    @Query(LocationApiConstants.queryParamLat) double lat,
    @Query(LocationApiConstants.queryParamLon) double lon,
    @Query(LocationApiConstants.queryParamAcceptLanguage) String acceptLanguage,
    @Query(LocationApiConstants.queryParamFormat) String format,
  );
}
