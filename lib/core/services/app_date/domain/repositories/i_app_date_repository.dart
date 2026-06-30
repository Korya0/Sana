import 'package:sana/core/networking/result.dart';

abstract class IAppDateRepository {
  int getHijriAdjustment();
  Future<Result<bool>> setHijriAdjustment(int adj);
  int getLastVerifiedHijriMonth();
  Future<Result<bool>> setLastVerifiedHijriMonth(int month);
}
