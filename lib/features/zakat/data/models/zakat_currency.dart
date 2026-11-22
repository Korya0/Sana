/// عملات الحساب المدعومة في الزكاة.
///
/// العملة المختارة هي عملة الحساب نفسها: تُرسل إلى مصدر الأسعار، وتُخزّن
/// في [ZakatInput]، وتُستخدم لكل المبالغ والأسعار وقيمة النصاب والنتائج.
/// لا يوجد تحويل عرض منفصل عن الحساب.
enum ZakatCurrency {
  egyptianPound('EGP', 'جنيه مصري', 'جنيه'),
  saudiRiyal('SAR', 'ريال سعودي', 'ريال'),
  uaeDirham('AED', 'درهم إماراتي', 'درهم'),
  usDollar('USD', 'دولار أمريكي', 'دولار'),
  euro('EUR', 'يورو', 'يورو'),
  britishPound('GBP', 'جنيه إسترليني', 'جنيه إسترليني'),
  kuwaitiDinar('KWD', 'دينار كويتي', 'دينار'),
  bahrainiDinar('BHD', 'دينار بحريني', 'دينار'),
  qatariRiyal('QAR', 'ريال قطري', 'ريال'),
  omaniRial('OMR', 'ريال عماني', 'ريال'),
  jordanianDinar('JOD', 'دينار أردني', 'دينار'),
  turkishLira('TRY', 'ليرة تركية', 'ليرة');

  const ZakatCurrency(this.code, this.label, this.suffix);

  /// رمز العملة وفق ISO 4217، ويُستخدم في طلب أسعار المعادن.
  final String code;

  /// الاسم الكامل بالعربية، ويظهر في قائمة الاختيار.
  final String label;

  /// اللاحقة المختصرة التي تُلحق بالمبالغ والأسعار.
  final String suffix;

  /// نص القائمة: الاسم العربي مع الرمز حتى لا يلتبس الجنيه بالريال مثلًا.
  String get menuLabel => '$label ($code)';
}
