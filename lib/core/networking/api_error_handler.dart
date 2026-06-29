import 'package:dio/dio.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';

/// Top-level function to handle API errors
Failure handleApiError(Object error, {String? customMessage}) {
  if (error is DioException) {
    return _handleDioError(error, customMessage);
  }

  // Default fallback for non-Dio errors
  return UnknownFailure(
    message: customMessage ?? AppStrings.ourFault,
  );
}

Failure _handleDioError(DioException error, String? customMessage) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkFailure(
        message: customMessage ?? AppStrings.noInternet,
      );

    case DioExceptionType.badResponse:
      return ServerFailure(
        message: customMessage ?? AppStrings.ourFault,
        statusCode: error.response?.statusCode,
      );

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
