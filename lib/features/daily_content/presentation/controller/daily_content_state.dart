import 'package:equatable/equatable.dart';
import 'package:sana/features/daily_content/data/models/daily_hadith_model.dart';
import 'package:sana/features/daily_content/data/models/dialy_sunan_model.dart';

enum DailyContentStatus { initial, loading, success, failure }

class DailyContentState extends Equatable {
  final DailyContentStatus status;
  final DailyHadith? dailyHadith;
  final DialySunanModel? dailySunnah;

  const DailyContentState({
    this.status = DailyContentStatus.initial,
    this.dailyHadith,
    this.dailySunnah,
  });

  DailyContentState copyWith({
    DailyContentStatus? status,
    DailyHadith? dailyHadith,
    DialySunanModel? dailySunnah,
  }) {
    return DailyContentState(
      status: status ?? this.status,
      dailyHadith: dailyHadith,
      dailySunnah: dailySunnah,
    );
  }

  @override
  List<Object?> get props => [status, dailyHadith, dailySunnah];
}
