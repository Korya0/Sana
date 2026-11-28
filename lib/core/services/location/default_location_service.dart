import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_platform.dart';
import 'package:sana/core/services/location/location_result.dart';
import 'package:sana/core/services/location/location_service.dart';
import 'package:sana/core/utils/app_logger.dart';

class DefaultLocationService implements LocationService {
  const DefaultLocationService({
    required this.logger,
    required this.platform,
  });

  final AppLogger logger;
  final LocationPlatform platform;

  // Permission status
  @override
  Future<Result<bool>> checkPermission() async {
    try {
      return Result.success(await platform.hasPermission());
    } on Object catch (error, stackTrace) {
      logger.error(
        'DefaultLocationService: checkPermission failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        PermissionFailure(message: AppStrings.qiblaDeniedTitle),
      );
    }
  }

  // Requests permission
  @override
  Future<Result<bool>> requestPermission() async {
    try {
      return Result.success(await platform.requestPermission());
    } on Object catch (error, stackTrace) {
      logger.error(
        'DefaultLocationService: requestPermission failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        PermissionFailure(message: AppStrings.qiblaDeniedTitle),
      );
    }
  }

  // Current location
  @override
  Future<Result<LocationResult>> getCurrentLocation() async {
    try {
      return Result.success(await platform.getCurrentPosition());
    } on Object catch (error, stackTrace) {
      logger.error(
        'DefaultLocationService: getCurrentLocation failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.qiblaFailedTitle),
      );
    }
  }

  // Location stream
  @override
  Stream<LocationResult> watchLocation() => platform.watchPosition();

  // App settings
  @override
  Future<Result<void>> openAppSettings() async {
    try {
      await platform.openAppSettings();
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      logger.error(
        'DefaultLocationService: openAppSettings failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        GeneralFailure(message: AppStrings.qiblaDeniedTitle),
      );
    }
  }

  // Location settings
  @override
  Future<Result<void>> openLocationSettings() async {
    try {
      await platform.openLocationSettings();
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      logger.error(
        'DefaultLocationService: openLocationSettings failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        GeneralFailure(message: AppStrings.qiblaFailedTitle),
      );
    }
  }
}
