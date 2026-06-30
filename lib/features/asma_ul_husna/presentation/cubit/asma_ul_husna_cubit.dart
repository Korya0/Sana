import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/core/networking/result.dart';

import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit(this._repository) : super(const AsmaUlHusnaInitial());
  final IAsmaUlHusnaRepository _repository;

  Future<void> loadNames() async {
    emit(const AsmaUlHusnaLoading());
    final result = await _repository.getNames();
    switch (result) {
      case Success(data: final names):
        emit(AsmaUlHusnaLoaded(names: names));
      case FailureResult(:final failure):
        emit(AsmaUlHusnaError(message: failure.message));
    }
  }

  Future<void> loadDailyName() async {
    final result = await _repository.getNameOfTheDay();
    switch (result) {
      case Success(data: final name):
        emit(DailyAsmaUlHusnaLoaded(name: name));
      case FailureResult(:final failure):
        emit(AsmaUlHusnaError(message: failure.message));
    }
  }
}
