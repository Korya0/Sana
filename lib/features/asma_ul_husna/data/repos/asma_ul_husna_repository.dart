import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';

abstract interface class IAsmaUlHusnaRepository {
  Future<Result<List<AsmaUlHusnaEntity>>> getNames();
}

class AsmaUlHusnaRepoImpl implements IAsmaUlHusnaRepository {
  AsmaUlHusnaRepoImpl(this._localDataSource);

  final IAsmaUlHusnaLocalDataSource _localDataSource;

  @override
  Future<Result<List<AsmaUlHusnaEntity>>> getNames() async {
    try {
      final names = await _localDataSource.getNames();
      if (names.isEmpty) {
        return const Result.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Result.success(names);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'GetNames Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
