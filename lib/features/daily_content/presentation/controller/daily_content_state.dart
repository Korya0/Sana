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
    this.isHadithFavorite = false,
    this.isSunnahFavorite = false,
  });
  final DailyContentStatus status;
  final DailyContentModel? dailyHadith;
  final DailyContentModel? dailySunnah;
  final AsmaulHusnaModel? dailyAsma;
  final bool hadithViewedToday;
  final bool sunnahViewedToday;
  final bool isHadithFavorite;
  final bool isSunnahFavorite;

  DailyContentState copyWith({
    DailyContentStatus? status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    AsmaulHusnaModel? dailyAsma,
    bool? hadithViewedToday,
    bool? sunnahViewedToday,
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
    isHadithFavorite,
    isSunnahFavorite,
  ];
}
