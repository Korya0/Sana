import 'package:sana/core/constants/constants.dart';

enum ReligiousEvent {
  startHijriYear(AppStrings.startHijriYear, 'startHijriYear'),
  reminderToFastAshura(AppStrings.reminderToFastAshura, 'reminderToFastAshura'),
  ashura(AppStrings.ashura, 'ashura'),
  ramadhan(AppStrings.ramadhan, 'ramadhan'),
  nightOfQadir(AppStrings.nightOfQadir, 'nightOfQadir'),
  eidAlFitr(AppStrings.eidAlFitr, 'EidAl-Fitr'),
  sixShawwal(AppStrings.sixShawwal, 'sexShawwal'),
  arafah(AppStrings.arafah, 'arafah'),
  tenDaysOfDhulHijjah(AppStrings.tenDaysOfDhulHijjah, 'tenDaysOfDhul-Hijjah'),
  eidAlAdha(AppStrings.eidAlAdha, 'EidAl-Adha'),
  unknown('', '');

  const ReligiousEvent(this.displayName, this.apiKey);

  final String displayName;
  final String apiKey;

  static ReligiousEvent fromApiKey(String key) {
    return ReligiousEvent.values.firstWhere(
      (event) => event.apiKey == key,
      orElse: () => ReligiousEvent.unknown,
    );
  }
}

class ReligiousEventDisplayNames {
  const ReligiousEventDisplayNames._();

  static String getName(String title) {
    final event = ReligiousEvent.fromApiKey(title);
    return event != ReligiousEvent.unknown ? event.displayName : title;
  }
}
