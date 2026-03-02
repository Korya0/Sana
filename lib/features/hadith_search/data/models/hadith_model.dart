import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/core/constants/api_constants.dart';
import 'package:sana/features/hadith_search/data/utils/hadith_html_parser.dart';

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
      return HadithHtmlParser.parseHtmlResponse(
        ahadith[ApiConstants.keyResult] as String,
      );
    }

    return [];
  }
}
