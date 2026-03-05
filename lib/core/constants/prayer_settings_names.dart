import 'package:adhan/adhan.dart';

/// Arabic display names for prayer calculation settings.
class PrayerSettingsNames {
  const PrayerSettingsNames._();

  /// Arabic names for calculation methods
  static const Map<CalculationMethod, String> calculationMethods = {
    CalculationMethod.muslim_world_league: 'رابطة العالم الإسلامي',
    CalculationMethod.egyptian: 'الهيئة العامة المصرية للمساحة',
    CalculationMethod.karachi: 'جامعة العلوم الإسلامية - كراتشي',
    CalculationMethod.umm_al_qura: 'أم القرى - مكة المكرمة',
    CalculationMethod.dubai: 'دبي',
    CalculationMethod.moon_sighting_committee: 'لجنة رؤية الهلال',
    CalculationMethod.north_america: 'أمريكا الشمالية',
    CalculationMethod.kuwait: 'الكويت',
    CalculationMethod.qatar: 'قطر',
    CalculationMethod.singapore: 'سنغافورة',
    CalculationMethod.tehran: 'طهران',
    CalculationMethod.turkey: 'تركيا',
  };

  /// Returns the Arabic name for a calculation method
  static String getMethodName(CalculationMethod method) {
    return calculationMethods[method] ?? method.name;
  }

  /// Returns the Arabic name for a madhab
  static String getMadhabName(Madhab madhab) {
    return madhab == Madhab.shafi ? 'الشافعي' : 'الحنفي';
  }
}
