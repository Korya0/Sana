import 'dart:async';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';

abstract class IAppDateRepository {
  int getHijriAdjustment();
  Future<ApiResult<bool>> setHijriAdjustment(int adj);
  int getLastVerifiedHijriMonth();
  Future<ApiResult<bool>> setLastVerifiedHijriMonth(int month);
}

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
        Failure.cache(message: AppStrings.hijriAdjustmentSaveError),
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
        Failure.cache(message: AppStrings.hijriMonthSaveError),
      );
    }
  }
}
