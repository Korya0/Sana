import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';

abstract class IAppDateRepository {
  int getHijriAdjustment();
  Future<Either<Failure, bool>> setHijriAdjustment(int adj);
  int getLastVerifiedHijriMonth();
  Future<Either<Failure, bool>> setLastVerifiedHijriMonth(int month);
}

class AppDateRepositoryImpl implements IAppDateRepository {
  AppDateRepositoryImpl(this._sharedPref);

  final ISharedPref _sharedPref;

  @override
  int getHijriAdjustment() {
    return _sharedPref.getInt(PrefKeys.hijriAdjustment) ?? 0;
  }

  @override
  Future<Either<Failure, bool>> setHijriAdjustment(int adj) async {
    try {
      await _sharedPref.setInt(PrefKeys.hijriAdjustment, adj);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  int getLastVerifiedHijriMonth() {
    return _sharedPref.getInt(PrefKeys.lastVerifiedHijriMonth) ?? 0;
  }

  @override
  Future<Either<Failure, bool>> setLastVerifiedHijriMonth(int month) async {
    try {
      await _sharedPref.setInt(PrefKeys.lastVerifiedHijriMonth, month);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
