import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/daily_asma_ul_husna_state.dart';

class DailyAsmaUlHusnaCubit extends Cubit<DailyAsmaUlHusnaState> {
  DailyAsmaUlHusnaCubit(this._repository, this._dateTimeProvider) 
      : super(const DailyAsmaUlHusnaState.initial());
  
  final IAsmaUlHusnaRepository _repository;
  final IDateTimeProvider _dateTimeProvider;

  Future<void> loadDailyName() async {
    emit(const DailyAsmaUlHusnaState.loading());
    final result = await _repository.getNames();
    switch (result) {
      case Success(data: final names):
        final now = _dateTimeProvider.now;
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        final dailyName = names[dayOfYear % names.length];
        emit(DailyAsmaUlHusnaState.loaded(dailyName));
      case FailureResult(:final failure):
        emit(DailyAsmaUlHusnaState.error(failure.message));
    }
  }
}
