import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'dorar_api_client.g.dart';

@RestApi()
abstract class DorarApiClient {
  factory DorarApiClient(Dio dio, {String baseUrl}) = _DorarApiClient;

  @GET('/dorar_api.json')
  Future<Map<String, dynamic>> searchHadith({
    @Query('skey') required String query,
    @Query('st') required String searchType,
    @Query('page') required String page,
  });
}
