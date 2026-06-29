import 'package:dio/dio.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';

class ApiErrorHandler {
  const ApiErrorHandler._();

  static Failure handle(Object error, {String? customMessage}) {
    if (error is DioException) {
      return _handleDioError(error, customMessage);
    }

    // Default fallback for non-Dio errors
    return UnknownFailure(
      message: customMessage ?? AppStrings.ourFault,
    );
  }

  static Failure _handleDioError(DioException error, String? customMessage) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: customMessage ?? AppStrings.noInternet,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return _handleBadResponse(statusCode, customMessage);

      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return ServerFailure(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.unknown:
        return UnknownFailure(
          message: customMessage ?? AppStrings.ourFault,
        );
    }
  }

  static Failure _handleBadResponse(int? statusCode, String? customMessage) {
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
      case 404:
        return ServerFailure(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: statusCode,
        );
    }
  }
}
