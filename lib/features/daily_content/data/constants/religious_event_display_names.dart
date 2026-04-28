import 'package:sana/core/constants/app_strings.dart';

class ReligiousEventDisplayNames {
  const ReligiousEventDisplayNames._();

  static String getName(String title) {
    switch (title) {
      case 'startHijriYear':
        return AppStrings.startHijriYear;
      case 'reminderToFastAshura':
        return AppStrings.reminderToFastAshura;
      case 'ashura':
        return AppStrings.ashura;
      case 'ramadhan':
        return AppStrings.ramadhan;
      case 'nightOfQadir':
        return AppStrings.nightOfQadir;
      case 'EidAl-Fitr':
        return AppStrings.eidAlFitr;
      case 'sexShawwal':
        return AppStrings.sixShawwal;
      case 'arafah':
        return AppStrings.arafah;
      case 'tenDaysOfDhul-Hijjah':
        return AppStrings.tenDaysOfDhulHijjah;
      case 'EidAl-Adha':
        return AppStrings.eidAlAdha;
      default:
        return title;
    }
  }
}
