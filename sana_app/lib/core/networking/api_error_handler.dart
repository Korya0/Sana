import 'package:dio/dio.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';

class ApiErrorHandler {
  const ApiErrorHandler._();

  static Failure handle(Object error, {String? customMessage}) {
    if (error is DioException) {
      return _handleDioError(error, customMessage);
    }

    // Default fallback for non-Dio errors
    return Failure.unknown(
      message: customMessage ?? AppStrings.ourFault,
    );
  }

  static Failure _handleDioError(DioException error, String? customMessage) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return Failure.network(
          message: customMessage ?? AppStrings.noInternet,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return _handleBadResponse(statusCode, customMessage);

      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return Failure.server(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.unknown:
        return Failure.unknown(
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
        return Failure.server(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return Failure.server(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: statusCode,
        );
      default:
        return Failure.server(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: statusCode,
        );
    }
  }
}
