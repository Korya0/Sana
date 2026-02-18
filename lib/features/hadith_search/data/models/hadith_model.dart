import 'package:html/parser.dart' as parser;
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

class HadithModel extends HadithEntity {
  const HadithModel({required super.hadithContent});

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(hadithContent: json['th'] ?? '');
  }

  static List<HadithModel> fromJsonList(Map<String, dynamic> json) {
    if (json['ahadith'] == null) return [];

    final ahadith = json['ahadith'];

    if (ahadith is List) {
      return ahadith
          .map((item) => HadithModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (ahadith is Map && ahadith['result'] is String) {
      return _parseHtmlResponse(ahadith['result']);
    }

    return [];
  }

  static List<HadithModel> _parseHtmlResponse(String htmlContent) {
    final document = parser.parse(htmlContent);
    final hadithElements = document.getElementsByClassName('hadith');
    final infoElements = document.getElementsByClassName('hadith-info');

    final List<HadithModel> hadiths = [];
    int count = hadithElements.length;
    if (infoElements.length < count) count = infoElements.length;

    for (int i = 0; i < count; i++) {
      // 1. تنظيف متن الحديث من الأرقام في البداية (مثل 1- أو 1 -)
      String hadithText = hadithElements[i].innerHtml.trim();
      hadithText = hadithText.replaceFirst(RegExp(r'^\d+\s*-\s*'), '');

      // 2. استخراج المعلومات بدقة باستخدام نظام "البحث عن العناوين"
      final String infoText = infoElements[i].text.trim();

      String extractField(String label) {
        if (!infoText.contains(label)) return "-";
        final int start = infoText.indexOf(label) + label.length;
        final List<String> labels = [
          "الراوي:",
          "المحدث:",
          "المصدر:",
          "الصفحة أو الرقم:",
          "خلاصة حكم المحدث:",
        ];
        int end = infoText.length;
        for (var l in labels) {
          final int index = infoText.indexOf(l, start);
          if (index != -1 && index < end) {
            end = index;
          }
        }
        return infoText.substring(start, end).replaceAll('|', '').trim();
      }

      final String narrator = extractField("الراوي:");
      final String scholar = extractField("المحدث:");
      final String source = extractField("المصدر:");
      final String page = extractField("الصفحة أو الرقم:");
      final String judgmentValue = extractField("خلاصة حكم المحدث:");

      // بناء هيكل HTML جديد ومنظم
      final String combinedHtml =
          '''
        <div class="hadith-body">$hadithText</div>
        <div class="divider"></div>
        <div class="info-row"><span class="lbl">الراوي:</span> $narrator | <span class="lbl">المحدث:</span> $scholar</div>
        <div class="info-row"><span class="lbl">المصدر:</span> $source | <span class="lbl">الصفحة:</span> $page</div>
        <div class="judgment-row">
          <span class="judgment-label">خلاصة حكم المحدث:</span> 
          <span class="judgment-value">$judgmentValue</span>
        </div>
      ''';

      hadiths.add(HadithModel(hadithContent: combinedHtml));
    }

    return hadiths;
  }
}
