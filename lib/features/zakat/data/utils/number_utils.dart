/// أدوات قراءة الأرقام وتنسيقها (تدعم الأرقام العربية والإنجليزية).
class NumberUtils {
  NumberUtils._();

  static const _arabicIndic = '٠١٢٣٤٥٦٧٨٩';
  static const _easternArabicIndic = '۰۱۲۳۴۵۶۷۸۹';

  /// تحويل الأرقام العربية/الفارسية وفواصلها إلى صيغة إنجليزية قابلة للقراءة.
  static String normalizeDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      final a = _arabicIndic.indexOf(ch);
      final p = _easternArabicIndic.indexOf(ch);
      if (a >= 0) {
        buffer.write(a);
      } else if (p >= 0) {
        buffer.write(p);
      } else if (ch == '٫') {
        buffer.write('.'); // الفاصلة العشرية العربية
      } else if (ch == '٬' || ch == ',' || ch == ' ') {
        // فاصل الآلاف: يُتجاهل
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  /// قراءة مبلغ من نص. يعيد null إذا كان النص غير صالح،
  /// ويعيد 0 إذا كان النص فارغًا (الحقول اختيارية).
  static double? parseAmount(String? text) {
    if (text == null || text.trim().isEmpty) return 0;
    final normalized = normalizeDigits(text.trim());
    final value = double.tryParse(normalized);
    if (value == null || value.isNaN || value.isInfinite || value < 0) {
      return null;
    }
    return value;
  }

  /// تنسيق مبلغ بفواصل آلاف وخانتين عشريتين عند الحاجة.
  static String formatAmount(double value) {
    final rounded = (value * 100).round() / 100;
    final isWhole = rounded == rounded.roundToDouble();
    final fixed = rounded.toStringAsFixed(isWhole ? 0 : 2);
    final parts = fixed.split('.');
    final intPart = parts[0];
    final grouped = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      final fromEnd = intPart.length - i;
      grouped.write(intPart[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) grouped.write(',');
    }
    return parts.length > 1 ? '$grouped.${parts[1]}' : grouped.toString();
  }

  static String formatMoney(double value) => '${formatAmount(value)} جنيه';

  static String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }
}
