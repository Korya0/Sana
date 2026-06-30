import 'package:intl/intl.dart';

extension GregorianFormatting on DateTime {
  /// Gregorian Full → الخميس، 11 ديسمبر 2014
  String toGregorianFull(String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(this);
}
