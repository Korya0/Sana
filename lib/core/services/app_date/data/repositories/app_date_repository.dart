import 'dart:async';

import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/app_date/domain/repositories/i_app_date_repository.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/utils/utils.dart';

class AppDateRepositoryImpl implements IAppDateRepository {
  AppDateRepositoryImpl(this._sharedPref);

  final ILocalStorageService _sharedPref;

  @override
  int getHijriAdjustment() {
    return _sharedPref.getInt(StorageKeys.hijriAdjustment) ?? 0;
  }

  @override
  Future<Result<bool>> setHijriAdjustment(int adj) async {
    try {
      await _sharedPref.setInt(StorageKeys.hijriAdjustment, adj);
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'SetHijriAdjustment Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(message: 'Failed to save Hijri adjustment'),
      );
    }
  }

  @override
  int getLastVerifiedHijriMonth() {
    return _sharedPref.getInt(StorageKeys.lastVerifiedHijriMonth) ?? 0;
  }

  @override
  Future<Result<bool>> setLastVerifiedHijriMonth(int month) async {
    try {
      await _sharedPref.setInt(StorageKeys.lastVerifiedHijriMonth, month);
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'SetLastVerifiedHijriMonth Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(message: 'Failed to save last verified Hijri month'),
      );
    }
  }
}
