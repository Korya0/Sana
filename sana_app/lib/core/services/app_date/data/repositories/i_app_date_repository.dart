import 'package:sana/core/networking/api_result.dart';

abstract class IAppDateRepository {
  int getHijriAdjustment();
  Future<ApiResult<bool>> setHijriAdjustment(int adj);
  int getLastVerifiedHijriMonth();
  Future<ApiResult<bool>> setLastVerifiedHijriMonth(int month);
  List<int> getVerificationMonths();
}
