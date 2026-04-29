enum HadithJudgment {
  sahih,
  hasan,
  daeef,
  unknown;

  static HadithJudgment fromString(String? judgment) {
    if (judgment == null) return HadithJudgment.unknown;
    final j = judgment.toLowerCase();
    if (j.contains('صحيح') || j.contains('جيد') || j.contains('ثابت')) {
      return HadithJudgment.sahih;
    }
    if (j.contains('حسن')) {
      return HadithJudgment.hasan;
    }
    if (j.contains('ضعيف') ||
        j.contains('منكر') ||
        j.contains('لا يصح') ||
        j.contains('موضوع') ||
        j.contains('باطل') ||
        j.contains('كذب')) {
      return HadithJudgment.daeef;
    }
    return HadithJudgment.unknown;
  }
}
