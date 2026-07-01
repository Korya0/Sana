import 'package:flutter/foundation.dart';
import 'package:sana/features/hadith_search/data/models/hadith_judgment.dart';

@immutable
class HadithEntity {
  const HadithEntity({
    required this.hadithContent,
    this.narrator,
    this.scholar,
    this.source,
    this.page,
    this.judgment,
    this.judgmentType = HadithJudgment.unknown,
    this.displayContent,
  });

  final String hadithContent;
  final String? narrator;
  final String? scholar;
  final String? source;
  final String? page;
  final String? judgment;
  final HadithJudgment judgmentType;
  final String? displayContent;

  String get effectiveContent => displayContent ?? hadithContent;

  HadithEntity copyWith({
    String? hadithContent,
    String? narrator,
    String? scholar,
    String? source,
    String? page,
    String? judgment,
    HadithJudgment? judgmentType,
    String? displayContent,
  }) {
    return HadithEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithEntity &&
        other.hadithContent == hadithContent &&
        other.narrator == narrator &&
        other.scholar == scholar &&
        other.source == source &&
        other.page == page &&
        other.judgment == judgment &&
        other.judgmentType == judgmentType &&
        other.displayContent == displayContent;
  }

  @override
  int get hashCode =>
      hadithContent.hashCode ^
      (narrator?.hashCode ?? 0) ^
      (scholar?.hashCode ?? 0) ^
      (source?.hashCode ?? 0) ^
      (page?.hashCode ?? 0) ^
      (judgment?.hashCode ?? 0) ^
      judgmentType.hashCode ^
      (displayContent?.hashCode ?? 0);
}
