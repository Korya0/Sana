import 'package:html/parser.dart' as parser;
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/core/constants/api_constants.dart';

class HadithModel extends HadithEntity {
  const HadithModel({
    required super.hadithContent,
    super.narrator,
    super.scholar,
    super.source,
    super.page,
    super.judgment,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      hadithContent:
          json[ApiConstants.keyHadithContent] as String? ??
          json[ApiConstants.keyTh] as String? ??
          '',
      narrator: json[ApiConstants.keyNarrator] as String?,
      scholar: json[ApiConstants.keyScholar] as String?,
      source: json[ApiConstants.keySource] as String?,
      page: json[ApiConstants.keyPage] as String?,
      judgment: json[ApiConstants.keyJudgment] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiConstants.keyHadithContent: hadithContent,
      ApiConstants.keyNarrator: narrator,
      ApiConstants.keyScholar: scholar,
      ApiConstants.keySource: source,
      ApiConstants.keyPage: page,
      ApiConstants.keyJudgment: judgment,
    };
  }

  static List<HadithModel> fromJsonList(Map<String, dynamic> json) {
    if (json[ApiConstants.keyAhadith] == null) return [];

    final ahadith = json[ApiConstants.keyAhadith];

    if (ahadith is List) {
      return ahadith
          .map((item) => HadithModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (ahadith is Map && ahadith[ApiConstants.keyResult] is String) {
      return _parseHtmlResponse(
        ahadith[ApiConstants.keyResult] as String,
      );
    }

    return [];
  }

  static List<HadithModel> _parseHtmlResponse(String htmlContent) {
    final document = parser.parse(htmlContent);
    final hadithElements = document.getElementsByClassName('hadith');
    final infoElements = document.getElementsByClassName('hadith-info');

    final hadiths = <HadithModel>[];
    var count = hadithElements.length;
    if (infoElements.length < count) count = infoElements.length;

    for (var i = 0; i < count; i++) {
      // 1. تنظيف متن الحديث من الأرقام في البداية (مثل 1- أو 1 -)
      var hadithText = hadithElements[i].innerHtml.trim();
      hadithText = hadithText.replaceFirst(RegExp(r'^\d+\s*-\s*'), '');

      // 2. استخراج المعلومات بدقة باستخدام نظام "البحث عن العناوين"
      final infoText = infoElements[i].text.trim();

      String extractField(String label) {
        if (!infoText.contains(label)) return '-';
        final start = infoText.indexOf(label) + label.length;
        final labels = <String>[
          AppStrings.narrator,
          AppStrings.scholar,
          AppStrings.source,
          AppStrings.pageOrNumber,
          AppStrings.scholarJudgment,
        ];
        var end = infoText.length;
        for (final l in labels) {
          final index = infoText.indexOf(l, start);
          if (index != -1 && index < end) {
            end = index;
          }
        }
        return infoText.substring(start, end).replaceAll('|', '').trim();
      }

      final narrator = extractField(AppStrings.narrator);
      final scholar = extractField(AppStrings.scholar);
      final source = extractField(AppStrings.source);
      final page = extractField(AppStrings.pageOrNumber);
      final judgmentValue = extractField(AppStrings.scholarJudgment);

      // بناء هيكل HTML جديد ومنظم
      final combinedHtml =
          '''
        <div class="hadith-body">$hadithText</div>
        <div class="divider"></div>
        <div class="info-row"><span class="lbl">${AppStrings.narrator}</span> $narrator | <span class="lbl">${AppStrings.scholar}</span> $scholar</div>
        <div class="info-row"><span class="lbl">${AppStrings.source}</span> $source | <span class="lbl">${AppStrings.page}</span> $page</div>
        <div class="judgment-row">
          <span class="judgment-label">${AppStrings.scholarJudgment}</span> 
          <span class="judgment-value">$judgmentValue</span>
        </div>
      ''';

      hadiths.add(
        HadithModel(
          hadithContent: combinedHtml,
          narrator: narrator,
          scholar: scholar,
          source: source,
          page: page,
          judgment: judgmentValue,
        ),
      );
    }

    return hadiths;
  }
}
