import 'package:sana/features/hadith_search/data/constants/hadith_api_constants.dart';
import 'package:sana/features/hadith_search/data/utils/hadith_html_parser.dart';

class HadithModel {
  const HadithModel({
    required this.hadithContent,
    this.narrator,
    this.scholar,
    this.source,
    this.page,
    this.judgment,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      hadithContent: json[HadithApiConstants.keyHadithContent] as String? ??
          json[HadithApiConstants.keyTh] as String? ??
          '',
      narrator: json[HadithApiConstants.keyNarrator] as String?,
      scholar: json[HadithApiConstants.keyScholar] as String?,
      source: json[HadithApiConstants.keySource] as String?,
      page: json[HadithApiConstants.keyPage] as String?,
      judgment: json[HadithApiConstants.keyJudgment] as String?,
    );
  }

  final String hadithContent;
  final String? narrator;
  final String? scholar;
  final String? source;
  final String? page;
  final String? judgment;

  Map<String, dynamic> toJson() {
    return {
      HadithApiConstants.keyHadithContent: hadithContent,
      HadithApiConstants.keyNarrator: narrator,
      HadithApiConstants.keyScholar: scholar,
      HadithApiConstants.keySource: source,
      HadithApiConstants.keyPage: page,
      HadithApiConstants.keyJudgment: judgment,
    };
  }

  static List<HadithModel> fromJsonList(Map<String, dynamic> json) {
    if (json[HadithApiConstants.keyAhadith] == null) return [];

    final ahadith = json[HadithApiConstants.keyAhadith];

    if (ahadith is List) {
      return ahadith
          .map((item) => HadithModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (ahadith is Map &&
        ahadith[HadithApiConstants.keyResult] is String) {
      return HadithHtmlParser.parseHtmlResponse(
        ahadith[HadithApiConstants.keyResult] as String,
      );
    }

    return [];
  }

  HadithModel copyWith({
    String? hadithContent,
    String? narrator,
    String? scholar,
    String? source,
    String? page,
    String? judgment,
  }) {
    return HadithModel(
      hadithContent: hadithContent ?? this.hadithContent,
      narrator: narrator ?? this.narrator,
      scholar: scholar ?? this.scholar,
      source: source ?? this.source,
      page: page ?? this.page,
      judgment: judgment ?? this.judgment,
    );
  }
}
