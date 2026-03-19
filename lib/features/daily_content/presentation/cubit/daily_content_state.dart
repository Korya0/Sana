import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

part 'daily_content_state.freezed.dart';

@freezed
class DailyContentState with _$DailyContentState {
  const factory DailyContentState({
    @Default(DailyContentStatus.initial) DailyContentStatus status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    AsmaulHusnaModel? dailyAsma,
    @Default(false) bool hadithViewedToday,
    @Default(false) bool sunnahViewedToday,
    @Default(false) bool isHadithFavorite,
    @Default(false) bool isSunnahFavorite,
  }) = _DailyContentState;
}

enum DailyContentStatus { initial, loading, success, failure }
