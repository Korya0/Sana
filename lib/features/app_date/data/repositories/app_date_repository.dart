import 'dart:async';

import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/utils/utils.dart';

abstract class IAppDateRepository {
  int getHijriAdjustment();
  Future<Result<bool>> setHijriAdjustment(int adj);
  int getLastVerifiedHijriMonth();
  Future<Result<bool>> setLastVerifiedHijriMonth(int month);
}

class AppDateRepositoryImpl implements IAppDateRepository {
  AppDateRepositoryImpl(this._localStorage);

  final ILocalStorageService _localStorage;

  @override
  int getHijriAdjustment() {
    return _localStorage.getInt(StorageKeys.hijriAdjustment) ?? 0;
  }

  @override
  Future<Result<bool>> setHijriAdjustment(int adj) async {
    try {
      await _localStorage.setInt(StorageKeys.hijriAdjustment, adj);
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.warn(
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
    return _localStorage.getInt(StorageKeys.lastVerifiedHijriMonth) ?? 0;
  }

  @override
  Future<Result<bool>> setLastVerifiedHijriMonth(int month) async {
    try {
      await _localStorage.setInt(StorageKeys.lastVerifiedHijriMonth, month);
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.warn(
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
