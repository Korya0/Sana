import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/daily_content/data/constants/daily_content_keys.dart';

part 'daily_content_model.freezed.dart';

enum DailyContentType { hadith, sunnah }

@freezed
class DailyContentModel with _$DailyContentModel {
  const factory DailyContentModel({
    required String content,
    required DailyContentType category,
    String? header,
    String? attribution,
    String? explanation,
  }) = _DailyContentModel;

  const DailyContentModel._();

  factory DailyContentModel.fromJson(
    Map<String, dynamic> json,
    DailyContentType category,
  ) {
    return DailyContentModel(
      header: json[DailyContentKeys.header] as String?,
      content: json[DailyContentKeys.content] as String,
      attribution: json[DailyContentKeys.attribution] as String?,
      explanation: json[DailyContentKeys.explanation] as String?,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DailyContentKeys.header: header,
      DailyContentKeys.content: content,
      DailyContentKeys.attribution: attribution,
      DailyContentKeys.explanation: explanation,
    };
  }
}
