import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

enum DailyContentStatus { initial, loading, success, failure }

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
}
