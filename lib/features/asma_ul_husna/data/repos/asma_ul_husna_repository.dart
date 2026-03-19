import 'dart:async';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

abstract class IAsmaUlHusnaRepository {
  Future<ApiResult<List<AsmaulHusnaModel>>> getNames();
  Future<ApiResult<AsmaulHusnaModel>> getNameOfTheDay();
}

class AsmaUlHusnaRepoImpl implements IAsmaUlHusnaRepository {
  @override
  Future<ApiResult<List<AsmaulHusnaModel>>> getNames() async {
    try {
      final names = await AsmaUlHusnaLocalDataSource.getNames();
      if (names.isEmpty) {
        return const ApiResult.failure(
          Failure.missingData(message: AppStrings.missingDataError),
        );
      }
      return ApiResult.success(names);
    } on Exception catch (e, stack) {
      unawaited(AppLogger.error('GetNames Error', error: e, stackTrace: stack));
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<AsmaulHusnaModel>> getNameOfTheDay() async {
    final result = await getNames();
    return result.when(
      success: (names) {
        final now = DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        return ApiResult.success(names[dayOfYear % names.length]);
      },
      failure: ApiResult.failure,
    );
  }
}
