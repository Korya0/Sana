import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';

import 'package:sana/features/asma_ul_husna/presentation/controller/asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit(this._repository) : super(const AsmaUlHusnaState.initial());
  final IAsmaUlHusnaRepository _repository;

  Future<void> loadNames() async {
    emit(const AsmaUlHusnaState.loading());
    final result = await _repository.getNames();
    result.when(
      success: (names) => emit(AsmaUlHusnaState.loaded(names: names)),
      failure: (failure) =>
          emit(AsmaUlHusnaState.error(message: failure.message)),
    );
  }
}
