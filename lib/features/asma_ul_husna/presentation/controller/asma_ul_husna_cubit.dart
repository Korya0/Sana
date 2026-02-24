import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/controller/asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit(this._repository) : super(AsmaUlHusnaInitial());
  final IAsmaUlHusnaRepository _repository;

  Future<void> loadNames() async {
    emit(AsmaUlHusnaLoading());
    final result = await _repository.getNames();
    result.fold(
      (failure) => emit(AsmaUlHusnaError(message: failure.message)),
      (names) => emit(AsmaUlHusnaLoaded(names: names)),
    );
  }
}
