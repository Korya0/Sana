import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';

import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit(this._repository) : super(const AsmaUlHusnaInitial());
  final IAsmaUlHusnaRepository _repository;

  Future<void> loadNames() async {
    emit(const AsmaUlHusnaLoading());
    final result = await _repository.getNames();
    result.when(
      success: (names) => emit(AsmaUlHusnaLoaded(names: names)),
      failure: (failure) => emit(AsmaUlHusnaError(message: failure.message)),
    );
  }
}
