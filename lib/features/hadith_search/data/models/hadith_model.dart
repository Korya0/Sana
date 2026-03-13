import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/hadith_search/data/constants/hadith_api_constants.dart';
import 'package:sana/features/hadith_search/data/utils/hadith_html_parser.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

part 'hadith_model.freezed.dart';

@freezed
class HadithModel with _$HadithModel {
  const factory HadithModel({
    required String hadithContent,
    String? narrator,
    String? scholar,
    String? source,
    String? page,
    String? judgment,
  }) = _HadithModel;

  const HadithModel._();

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      hadithContent:
          json[HadithApiConstants.keyHadithContent] as String? ??
          json[HadithApiConstants.keyTh] as String? ??
          '',
      narrator: json[HadithApiConstants.keyNarrator] as String?,
      scholar: json[HadithApiConstants.keyScholar] as String?,
      source: json[HadithApiConstants.keySource] as String?,
      page: json[HadithApiConstants.keyPage] as String?,
      judgment: json[HadithApiConstants.keyJudgment] as String?,
    );
  }

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
}

extension HadithModelX on HadithModel {
  HadithEntity toEntity() => HadithEntity(
    hadithContent: hadithContent,
    narrator: narrator,
    scholar: scholar,
    source: source,
    page: page,
    judgment: judgment,
  );
}

extension HadithEntityX on HadithEntity {
  HadithModel toModel() => HadithModel(
    hadithContent: hadithContent,
    narrator: narrator,
    scholar: scholar,
    source: source,
    page: page,
    judgment: judgment,
  );
}
