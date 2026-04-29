import 'package:sana/features/hadith_search/constants/hadith_api_constants.dart';
import 'package:sana/features/hadith_search/data/models/hadith_judgment.dart';
import 'package:sana/features/hadith_search/utils/hadith_html_parser.dart';

class HadithModel {
  const HadithModel({
    required this.hadithContent,
    this.narrator,
    this.scholar,
    this.source,
    this.page,
    this.judgment,
    this.judgmentType = HadithJudgment.unknown,
    this.displayContent,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    final judgment = json[HadithApiConstants.keyJudgment] as String?;
    return HadithModel(
      hadithContent:
          json[HadithApiConstants.keyHadithContent] as String? ??
          json[HadithApiConstants.keyTh] as String? ??
          '',
      narrator: json[HadithApiConstants.keyNarrator] as String?,
      scholar: json[HadithApiConstants.keyScholar] as String?,
      source: json[HadithApiConstants.keySource] as String?,
      page: json[HadithApiConstants.keyPage] as String?,
      judgment: judgment,
      judgmentType: HadithJudgment.fromString(judgment),
    );
  }

  final String hadithContent;
  final String? narrator;
  final String? scholar;
  final String? source;
  final String? page;
  final String? judgment;
  final HadithJudgment judgmentType;
  final String? displayContent;

  String get effectiveContent => displayContent ?? hadithContent;

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
    HadithJudgment? judgmentType,
    String? displayContent,
  }) {
    return HadithModel(
      hadithContent: hadithContent ?? this.hadithContent,
      narrator: narrator ?? this.narrator,
      scholar: scholar ?? this.scholar,
      source: source ?? this.source,
      page: page ?? this.page,
      judgment: judgment ?? this.judgment,
      judgmentType: judgmentType ?? this.judgmentType,
      displayContent: displayContent ?? this.displayContent,
    );
  }
}
