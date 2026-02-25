import 'package:equatable/equatable.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

enum DailyContentStatus { initial, loading, success, failure }

class DailyContentState extends Equatable {
  const DailyContentState({
    this.status = DailyContentStatus.initial,
    this.dailyHadith,
    this.dailySunnah,
    this.dailyAsma,
    this.hadithViewedToday = false,
    this.sunnahViewedToday = false,
    this.hadithProgress = 0,
    this.sunnahProgress = 0,
    this.asmaProgress = 0,
    this.totalHadiths = 0,
    this.totalSunnah = 0,
    this.totalAsma = 0,
    this.isHadithFavorite = false,
    this.isSunnahFavorite = false,
  });
  final DailyContentStatus status;
  final DailyContentModel? dailyHadith;
  final DailyContentModel? dailySunnah;
  final AsmaulHusnaModel? dailyAsma;
  final bool hadithViewedToday;
  final bool sunnahViewedToday;
  final int hadithProgress; // Current index in the shuffled list
  final int sunnahProgress; // Current index in the shuffled list
  final int asmaProgress;
  final int totalHadiths;
  final int totalSunnah;
  final int totalAsma;
  final bool isHadithFavorite;
  final bool isSunnahFavorite;

  DailyContentState copyWith({
    DailyContentStatus? status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    AsmaulHusnaModel? dailyAsma,
    bool? hadithViewedToday,
    bool? sunnahViewedToday,
    int? hadithProgress,
    int? sunnahProgress,
    int? asmaProgress,
    int? totalHadiths,
    int? totalSunnah,
    int? totalAsma,
    bool? isHadithFavorite,
    bool? isSunnahFavorite,
  }) {
    return DailyContentState(
      status: status ?? this.status,
      dailyHadith: dailyHadith ?? this.dailyHadith,
      dailySunnah: dailySunnah ?? this.dailySunnah,
      dailyAsma: dailyAsma ?? this.dailyAsma,
      hadithViewedToday: hadithViewedToday ?? this.hadithViewedToday,
      sunnahViewedToday: sunnahViewedToday ?? this.sunnahViewedToday,
      hadithProgress: hadithProgress ?? this.hadithProgress,
      sunnahProgress: sunnahProgress ?? this.sunnahProgress,
      asmaProgress: asmaProgress ?? this.asmaProgress,
      totalHadiths: totalHadiths ?? this.totalHadiths,
      totalSunnah: totalSunnah ?? this.totalSunnah,
      totalAsma: totalAsma ?? this.totalAsma,
      isHadithFavorite: isHadithFavorite ?? this.isHadithFavorite,
      isSunnahFavorite: isSunnahFavorite ?? this.isSunnahFavorite,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dailyHadith,
    dailySunnah,
    dailyAsma,
    hadithViewedToday,
    sunnahViewedToday,
    hadithProgress,
    sunnahProgress,
    asmaProgress,
    totalHadiths,
    totalSunnah,
    totalAsma,
    isHadithFavorite,
    isSunnahFavorite,
  ];
}
