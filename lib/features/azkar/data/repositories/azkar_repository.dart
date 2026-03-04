import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class IAzkarRepository {
  Future<Either<Failure, List<AzkarCategoryModel>>> getAllCategories();
  Future<Either<Failure, AzkarCategoryModel>> getItemById(String id);
}

class AzkarRepository implements IAzkarRepository {
  AzkarRepository(this._dataSource);
  final AzkarLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<AzkarCategoryModel>>> getAllCategories() async {
    try {
      final items = await _dataSource.getAllCategories();
      if (items.isEmpty) {
        return const Left(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Right(items);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('GetAllCategories Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AzkarCategoryModel>> getItemById(String id) async {
    try {
      final result = await getAllCategories();
      return result.fold(
        Left.new,
        (categories) {
          try {
            final item = categories.firstWhere((e) => e.id == id);
            return Right(item);
          } catch (e, stack) {
            unawaited(
              AppLogger.error(
                'ItemById Filter Error',
                error: e,
                stackTrace: stack,
              ),
            );
            return const Left(
              MissingDataFailure(message: AppStrings.missingDataError),
            );
          }
        },
      );
    } catch (e, stack) {
      unawaited(
        AppLogger.error('GetItemById Main Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
