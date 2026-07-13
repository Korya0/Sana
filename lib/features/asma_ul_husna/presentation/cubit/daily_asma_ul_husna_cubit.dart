import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/daily_asma_ul_husna_state.dart';

class DailyAsmaUlHusnaCubit extends Cubit<DailyAsmaUlHusnaState> {
  DailyAsmaUlHusnaCubit(this._repository, this._appDateCubit)
    : super(const DailyAsmaUlHusnaState.initial());

  final IAsmaUlHusnaRepository _repository;
  final AppDateCubit _appDateCubit;

  Future<void> loadDailyName() async {
    if (isClosed) return;
    emit(const DailyAsmaUlHusnaState.loading());
    final result = await _repository.getNames();
    if (isClosed) return;
    switch (result) {
      case Success(data: final names):
        final appState = _appDateCubit.state;
        final now = appState is AppDateLoaded
            ? appState.date.gregorian
            : DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        final dailyName = names[dayOfYear % names.length];
        emit(DailyAsmaUlHusnaState.loaded(dailyName));
      case FailureResult(:final failure):
        emit(DailyAsmaUlHusnaState.error(failure.message));
    }
  }
}
