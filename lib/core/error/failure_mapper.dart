import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';

class FailureMapper {
  const FailureMapper._();

  /// Maps a technical [Failure] into a user-friendly localized [String].
  static String mapFailureToMessage(Failure failure) {
    switch (failure) {
      case NetworkFailure():
        return AppStrings.noInternet;
      case ServerFailure():
      case CacheFailure():
        return AppStrings.ourFault;
      case LocationFailure():
        return AppStrings.locationError;
      case SensorFailure():
        return AppStrings.sensorError;
      case WrongPasswordFailure():
        return AppStrings.invalidPin;
      case MissingDataFailure():
        return AppStrings.missingDataError;
      case UnknownFailure():
        return AppStrings.ourFault;
    }
  }
}
