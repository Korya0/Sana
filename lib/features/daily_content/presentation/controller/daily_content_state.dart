import 'package:equatable/equatable.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

enum DailyContentStatus { initial, loading, success, failure }

class DailyContentState extends Equatable {
  final DailyContentStatus status;
  final DailyContentModel? dailyHadith;
  final DailyContentModel? dailySunnah;
  final bool hadithViewedToday;
  final bool sunnahViewedToday;
  final int hadithProgress; // Current index in the shuffled list
  final int sunnahProgress; // Current index in the shuffled list
  final int totalHadiths;
  final int totalSunnah;
  final bool isHadithFavorite;
  final bool isSunnahFavorite;

  const DailyContentState({
    this.status = DailyContentStatus.initial,
    this.dailyHadith,
    this.dailySunnah,
    this.hadithViewedToday = false,
    this.sunnahViewedToday = false,
    this.hadithProgress = 0,
    this.sunnahProgress = 0,
    this.totalHadiths = 0,
    this.totalSunnah = 0,
    this.isHadithFavorite = false,
    this.isSunnahFavorite = false,
  });

  DailyContentState copyWith({
    DailyContentStatus? status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    bool? hadithViewedToday,
    bool? sunnahViewedToday,
    int? hadithProgress,
    int? sunnahProgress,
    int? totalHadiths,
    int? totalSunnah,
    bool? isHadithFavorite,
    bool? isSunnahFavorite,
  }) {
    return DailyContentState(
      status: status ?? this.status,
      dailyHadith: dailyHadith ?? this.dailyHadith,
      dailySunnah: dailySunnah ?? this.dailySunnah,
      hadithViewedToday: hadithViewedToday ?? this.hadithViewedToday,
      sunnahViewedToday: sunnahViewedToday ?? this.sunnahViewedToday,
      hadithProgress: hadithProgress ?? this.hadithProgress,
      sunnahProgress: sunnahProgress ?? this.sunnahProgress,
      totalHadiths: totalHadiths ?? this.totalHadiths,
      totalSunnah: totalSunnah ?? this.totalSunnah,
      isHadithFavorite: isHadithFavorite ?? this.isHadithFavorite,
      isSunnahFavorite: isSunnahFavorite ?? this.isSunnahFavorite,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dailyHadith,
    dailySunnah,
    hadithViewedToday,
    sunnahViewedToday,
    hadithProgress,
    sunnahProgress,
    totalHadiths,
    totalSunnah,
    isHadithFavorite,
    isSunnahFavorite,
  ];
}
