import 'package:hijri/hijri_calendar.dart';
import 'package:sana/core/constants/religious_event_display_names.dart';

class ReligiousEventModel {
  ReligiousEventModel({
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
  final int id;
  final String title;
  final int month;
  final List<int> days;
  final String? hadithText;
  final String? bookInfo;

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

  String get displayName => ReligiousEventDisplayNames.getName(title);
}
