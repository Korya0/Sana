import 'package:sana/features/prayer/data/models/prayer_calculation_settings.dart';

class PrayerSettingsNames {
  const PrayerSettingsNames._();

  static const Map<CalculationMethodEntity, String> calculationMethods = {
    CalculationMethodEntity.muslimWorldLeague: 'رابطة العالم الإسلامي',
    CalculationMethodEntity.egyptian: 'الهيئة العامة المصرية للمساحة',
    CalculationMethodEntity.karachi: 'جامعة العلوم الإسلامية - كراتشي',
    CalculationMethodEntity.ummAlQura: 'أم القرى - مكة المكرمة',
    CalculationMethodEntity.dubai: 'دبي',
    CalculationMethodEntity.moonSightingCommittee: 'لجنة رؤية الهلال',
    CalculationMethodEntity.northAmerica: 'أمريكا الشمالية',
    CalculationMethodEntity.kuwait: 'الكويت',
    CalculationMethodEntity.qatar: 'قطر',
    CalculationMethodEntity.singapore: 'سنغافورة',
    CalculationMethodEntity.tehran: 'طهران',
    CalculationMethodEntity.turkey: 'تركيا',
    CalculationMethodEntity.other: 'أخرى',
  };

  static String getMethodName(CalculationMethodEntity method) {
    return calculationMethods[method] ?? method.name;
  }

  static String getMadhabName(MadhabEntity madhab) {
    return madhab == MadhabEntity.shafi ? 'الشافعي' : 'الحنفي';
  }
}
