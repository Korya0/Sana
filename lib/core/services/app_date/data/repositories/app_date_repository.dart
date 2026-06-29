import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/utils.dart';

import 'package:sana/core/services/app_date/data/repositories/i_app_date_repository.dart';

class AppDateRepositoryImpl implements IAppDateRepository {
  AppDateRepositoryImpl(this._sharedPref);

  final ILocalStorageService _sharedPref;

  @override
  int getHijriAdjustment() {
    return _sharedPref.getInt(StorageKeys.hijriAdjustment) ?? 0;
  }

  @override
  Future<ApiResult<bool>> setHijriAdjustment(int adj) async {
    try {
      await _sharedPref.setInt(StorageKeys.hijriAdjustment, adj);
      return const ApiResult.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'SetHijriAdjustment Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const ApiResult.failure(
        CacheFailure(message: AppStrings.hijriAdjustmentSaveError),
      );
    }
  }

  @override
  int getLastVerifiedHijriMonth() {
    return _sharedPref.getInt(StorageKeys.lastVerifiedHijriMonth) ?? 0;
  }

  @override
  Future<ApiResult<bool>> setLastVerifiedHijriMonth(int month) async {
    try {
      await _sharedPref.setInt(StorageKeys.lastVerifiedHijriMonth, month);
      return const ApiResult.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'SetLastVerifiedHijriMonth Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const ApiResult.failure(
        CacheFailure(message: AppStrings.hijriMonthSaveError),
      );
    }
  }

  @override
  List<int> getVerificationMonths() {
    return const [
      9, // رمضان (Ramadan)
      11, // ذو القعدة (Dhu al-Qi'dah)
      12, // ذو الحجة (Dhu al-Hijjah)
    ];
  }
}
