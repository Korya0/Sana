import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/utils/device_info_service.dart';
import 'package:sana/features/report/constant/firestore_keys.dart';
import 'package:sana/features/report/constant/string_constant.dart';
import 'package:sana/features/report/data/datasources/report_remote_data_source.dart';
import 'package:sana/features/report/data/models/report_model.dart';

abstract class IReportRepository {
  Future<Either<Failure, bool>> sendReport({
    required String message,
    String? errorDetails,
    String? contactInfo,
    bool isSuggestion = false,
  });
}

class ReportRepository implements IReportRepository {
  ReportRepository(this._remoteDataSource, this._deviceInfoService);

  final IReportRemoteDataSource _remoteDataSource;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<Either<Failure, bool>> sendReport({
    required String message,
    String? errorDetails,
    String? contactInfo,
    bool isSuggestion = false,
  }) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final type = errorDetails != null
          ? FirestoreKeys.system
          : FirestoreKeys.user;
      final metadata = await _deviceInfoService.getDeviceInfo();

      final reportModel = ReportModel(
        message: message,
        contactInfo: contactInfo ?? StringConstant.notAvailable,
        errorDetails: (errorDetails == null || errorDetails.isEmpty)
            ? StringConstant.notFound
            : errorDetails,
        isSuggestion: isSuggestion,
        type: type,
        timestamp: timestamp,
        metadata: metadata,
      );

      await _remoteDataSource.sendReport(reportModel.toJson());
      AppLogger.success('Report sent successfully with metadata!');
      return const Right(true);
    } catch (e, stack) {
      AppLogger.error(
        'Error sending report',
        error: e,
        stackTrace: stack,
      );

      // Check if it's a network error (like unavailable in Firestore)
      if (e.toString().contains(FirestoreKeys.unavailable) ||
          e.toString().contains(FirestoreKeys.network) ||
          e.toString().contains(FirestoreKeys.socketException)) {
        return const Left(
          NetworkFailure(
            message: StringConstant.noInternet,
          ),
        );
      }

      return Left(
        ServerFailure(
          message: StringConstant.serverError,
          technicalMessage: StringConstant.firestoreError + e.toString(),
        ),
      );
    }
  }
}
