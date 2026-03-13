import 'package:dio/dio.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure map(Object error, {String? customMessage}) {
    if (error is DioException) {
      return _handleDioError(error, customMessage);
    }

    // Default fallback
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
        return Failure.server(
          message: customMessage ?? AppStrings.ourFault,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return Failure.server(
          message: customMessage ?? AppStrings.ourFault,
        );
    }
  }
}
