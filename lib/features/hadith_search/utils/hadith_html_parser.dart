import 'package:html/parser.dart' as parser;
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';

class HadithHtmlParser {
  static List<HadithModel> parseHtmlResponse(String htmlContent) {
    final document = parser.parse(htmlContent);
    final hadithElements = document.getElementsByClassName('hadith');
    final infoElements = document.getElementsByClassName('hadith-info');

    final hadiths = <HadithModel>[];
    var count = hadithElements.length;
    if (infoElements.length < count) count = infoElements.length;

    for (var i = 0; i < count; i++) {
      // 1. Clean hadith content from leading numbers (e.g. 1- or 1 -)
      var hadithText = hadithElements[i].innerHtml.trim();
      hadithText = hadithText.replaceFirst(RegExp(r'^\d+\s*-\s*'), '');

      // 2. Extract information accurately using field labels
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

      // Construct a new organized HTML structure for display
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
