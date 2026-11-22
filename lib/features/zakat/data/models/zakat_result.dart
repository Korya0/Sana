import 'zakat_currency.dart';
import 'zakat_input.dart';

/// حالة نتيجة الحساب.
enum ZakatStatus {
  /// تحققت الشروط، وهناك زكاة تقديرية.
  due,

  /// صافي المال أقل من النصاب.
  belowNisab,

  /// بلغ النصاب لكن لم يتم الحول.
  hawlNotCompleted,

  /// لم يُدخل المستخدم سعر الذهب/الفضة فلا يمكن معرفة النصاب أو قيمة المعدن.
  nisabUnknown,
}

class ZakatResult {
  const ZakatResult({
    required this.input,
    required this.totalAssets,
    required this.appliedDeductions,
    required this.netAmount,
    required this.nisabValue,
    required this.status,
    required this.zakatAmount,
    required this.excludedPersonalGold,
    required this.goldValue,
    required this.silverValue,
    required this.goldPureGrams,
  });

  final ZakatInput input;

  /// إجمالي الأموال المحتسبة (بعد استبعاد ما لا يدخل في الوعاء).
  final double totalAssets;

  /// الخصومات المطبّقة فعليًا (لا تتجاوز إجمالي الأموال).
  final double appliedDeductions;

  /// صافي المال الخاضع للزكاة.
  final double netAmount;

  /// قيمة النصاب بعملة الحساب، أو null إذا لم يُدخل السعر.
  final double? nisabValue;

  final ZakatStatus status;

  /// مقدار الزكاة التقديري (0 إذا لم تجب).
  final double zakatAmount;

  /// قيمة الذهب الشخصي التي استُبعدت من الحساب (إن وجدت).
  final double excludedPersonalGold;

  /// قيمة الذهب المحتسبة بعملة الحساب (وزن × سعر الجرام).
  final double goldValue;

  /// قيمة الفضة المحتسبة بعملة الحساب (وزن × سعر الجرام).
  final double silverValue;

  /// وزن الذهب المحتسب محوّلًا إلى ذهب خالص (عيار 24).
  final double goldPureGrams;

  bool get isDue => status == ZakatStatus.due;

  /// عملة الحساب التي حُسبت بها كل قيم النتيجة.
  ZakatCurrency get currency => input.currency;
}
