part of 'daily_content_cubit.dart';

enum DailyContentStatus { initial, loading, success, failure }

class DailyContentState extends Equatable {
  final DailyContentStatus status;
  final DailyHadith? dailyHadith;
  final DailySunnah? dailySunnah;

  const DailyContentState({
    this.status = DailyContentStatus.initial,
    this.dailyHadith,
    this.dailySunnah,
  });

  DailyContentState copyWith({
    DailyContentStatus? status,
    DailyHadith? dailyHadith,
    DailySunnah? dailySunnah,
  }) {
    return DailyContentState(
      status: status ?? this.status,
      dailyHadith: dailyHadith ?? this.dailyHadith,
      dailySunnah: dailySunnah ?? this.dailySunnah,
    );
  }

  @override
  List<Object?> get props => [status, dailyHadith, dailySunnah];
}
