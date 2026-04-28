import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sana/features/daily_content/constants/religious_event_display_names.dart';

part 'religious_event_model.freezed.dart';

@freezed
class ReligiousEventModel with _$ReligiousEventModel {
  const factory ReligiousEventModel({
    required int id,
    required String title,
    required int month,
    required List<int> days,
    String? hadithText,
    String? bookInfo,
  }) = _ReligiousEventModel;

  const ReligiousEventModel._();

  factory ReligiousEventModel.fromJson(Map<String, dynamic> json) {
    final hadithList = json['hadith'] as List<dynamic>?;
    final firstHadith = hadithList != null && hadithList.isNotEmpty
        ? hadithList[0] as Map<String, dynamic>
        : null;

    return ReligiousEventModel(
      id: json['id'] as int,
      title: json['title'] as String,
      month: json['month'] as int,
      days: List<int>.from(json['day'] as List<dynamic>),
      hadithText: firstHadith?['hadith'] as String?,
      bookInfo: firstHadith?['bookInfo'] as String?,
    );
  }

  bool isOccurring(HijriCalendar hijri) {
    return hijri.hMonth == month && days.contains(hijri.hDay);
  }

  bool isAfter(HijriCalendar hijri) {
    if (month > hijri.hMonth) return true;
    if (month == hijri.hMonth && days.isNotEmpty && days.first > hijri.hDay) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'month': month,
      'day': days,
      'hadith': hadithText != null
          ? [
              {'hadith': hadithText, 'bookInfo': bookInfo},
            ]
          : <Map<String, dynamic>>[],
    };
  }

  String get displayName => ReligiousEventDisplayNames.getName(title);
}
