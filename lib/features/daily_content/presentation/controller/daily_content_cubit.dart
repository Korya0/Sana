import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/features/daily_content/data/datasource/daily_hadith_data.dart';
import 'package:sana/features/daily_content/data/datasource/daily_sunnah_data.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  final AppDateCubit appDateCubit;
  DailyContentCubit(this.appDateCubit) : super(const DailyContentState()) {
    // Load daily content in the background after the first frame
    Future.microtask(loadDailyContent);
  }

  Future<void> loadDailyContent() async {
    try {
      emit(state.copyWith(status: DailyContentStatus.loading));

      const hadithsData = DailyHadithData.hadithList;
      const sunnahsData = DailySunnahData.sunanList;

      if (hadithsData.isEmpty || sunnahsData.isEmpty) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      final now = appDateCubit.currentDate.toUtc();
      final diff = now.difference(DateTime(now.year));
      final dayOfYear = diff.inDays;

      final hadithIndex = dayOfYear % hadithsData.length;
      final sunnahIndex = dayOfYear % sunnahsData.length;

      emit(
        state.copyWith(
          status: DailyContentStatus.success,
          dailyHadith: hadithsData[hadithIndex],
          dailySunnah: sunnahsData[sunnahIndex],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }
}
