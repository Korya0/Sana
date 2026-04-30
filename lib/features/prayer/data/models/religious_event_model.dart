import 'package:hijri/hijri_calendar.dart';
import 'package:sana/core/constants/religious_event_display_names.dart';

class ReligiousEventModel {
  const ReligiousEventModel({
    required this.id,
    required this.title,
    required this.month,
    required this.days,
    this.hadithText,
    this.bookInfo,
  });

  factory ReligiousEventModel.fromJson(Map<String, dynamic> json) {
    final hadithList = json['hadith'] as List<dynamic>?;
    final firstHadith = hadithList != null && hadithList.isNotEmpty
        ? firstHadithFromList(hadithList)
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

  final int id;
  final String title;
  final int month;
  final List<int> days;
  final String? hadithText;
  final String? bookInfo;

  static Map<String, dynamic>? firstHadithFromList(List<dynamic> list) {
    return list[0] as Map<String, dynamic>;
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

  ReligiousEventModel copyWith({
    int? id,
    String? title,
    int? month,
    List<int>? days,
    String? hadithText,
    String? bookInfo,
  }) {
    return ReligiousEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      month: month ?? this.month,
      days: days ?? this.days,
      hadithText: hadithText ?? this.hadithText,
      bookInfo: bookInfo ?? this.bookInfo,
    );
  }
}
