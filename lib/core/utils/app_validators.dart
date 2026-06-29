import 'package:sana/core/constants/constants.dart';

const String arabicLettersAndSpacesPattern = r'[ء-ي\s]';

String? validateFeedbackIssue(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.writeDetails;
  }
  if (value.trim().length < 10) {
    return AppStrings.writeDetailsLateset10Characters;
  }
  return null;
}
