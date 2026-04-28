import 'package:flutter/foundation.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

enum DailyContentStatus { initial, loading, success, failure }

@immutable
class DailyContentState {
  const DailyContentState({
    this.status = DailyContentStatus.initial,
    this.dailyHadith,
    this.dailySunnah,
    this.hadithViewedToday = false,
    this.sunnahViewedToday = false,
    this.isHadithFavorite = false,
    this.isSunnahFavorite = false,
  });

  final DailyContentStatus status;
  final DailyContentModel? dailyHadith;
  final DailyContentModel? dailySunnah;
  final bool hadithViewedToday;
  final bool sunnahViewedToday;
  final bool isHadithFavorite;
  final bool isSunnahFavorite;

  DailyContentState copyWith({
    DailyContentStatus? status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    bool? hadithViewedToday,
    bool? sunnahViewedToday,
    bool? isHadithFavorite,
    bool? isSunnahFavorite,
  }) {
    return DailyContentState(
      status: status ?? this.status,
      dailyHadith: dailyHadith ?? this.dailyHadith,
      dailySunnah: dailySunnah ?? this.dailySunnah,
      hadithViewedToday: hadithViewedToday ?? this.hadithViewedToday,
      sunnahViewedToday: sunnahViewedToday ?? this.sunnahViewedToday,
      isHadithFavorite: isHadithFavorite ?? this.isHadithFavorite,
      isSunnahFavorite: isSunnahFavorite ?? this.isSunnahFavorite,
    );
  }
  @override
  String toString() {
    return 'DailyContentState(status: $status, hadithViewedToday: $hadithViewedToday, sunnahViewedToday: $sunnahViewedToday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyContentState &&
        other.status == status &&
        other.dailyHadith == dailyHadith &&
        other.dailySunnah == dailySunnah &&
        other.hadithViewedToday == hadithViewedToday &&
        other.sunnahViewedToday == sunnahViewedToday &&
        other.isHadithFavorite == isHadithFavorite &&
        other.isSunnahFavorite == isSunnahFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      dailyHadith,
      dailySunnah,
      hadithViewedToday,
      sunnahViewedToday,
      isHadithFavorite,
      isSunnahFavorite,
    );
  }
}
