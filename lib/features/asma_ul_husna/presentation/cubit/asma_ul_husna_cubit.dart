import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/core/networking/result.dart';

import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit(this._repository) : super(const AsmaUlHusnaState.initial());
  
  final IAsmaUlHusnaRepository _repository;

  Future<void> loadNames() async {
    emit(const AsmaUlHusnaState.loading());
    final result = await _repository.getNames();

    if (isClosed) return;

    switch (result) {
      case Success(data: final names):
        emit(AsmaUlHusnaState.loaded(names));
      case FailureResult(:final failure):
        emit(AsmaUlHusnaState.error(failure.message));
    }
  }
}
