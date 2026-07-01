import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/constants.dart';

/// كيان المناسبات الدينية (Domain Entity).
/// لا يحتوي على أي منطق عمل - الفحوصات الزمنية تكون في Use Cases.
@immutable
class ReligiousEventEntity {
  const ReligiousEventEntity({
    required this.id,
    required this.title,
    required this.month,
    required this.days,
    this.hadithText,
    this.bookInfo,
  });

  final int id;
  final String title;
  final int month;
  final List<int> days;
  final String? hadithText;
  final String? bookInfo;

  String get displayName => ReligiousEventDisplayNames.getName(title);

  ReligiousEventEntity copyWith({
    int? id,
    String? title,
    int? month,
    List<int>? days,
    String? hadithText,
    String? bookInfo,
  }) {
    return ReligiousEventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      month: month ?? this.month,
      days: days ?? this.days,
      hadithText: hadithText ?? this.hadithText,
      bookInfo: bookInfo ?? this.bookInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReligiousEventEntity) return false;
    if (id != other.id ||
        title != other.title ||
        month != other.month ||
        hadithText != other.hadithText ||
        bookInfo != other.bookInfo) {
      return false;
    }
    if (days.length != other.days.length) return false;
    for (var i = 0; i < days.length; i++) {
      if (days[i] != other.days[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      month.hashCode ^
      days.hashCode ^
      hadithText.hashCode ^
      bookInfo.hashCode;
}
