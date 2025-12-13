import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_asma_ul_husna_usecase.dart';
import 'asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  final GetAsmaUlHusnaUseCase getAsmaUlHusnaUseCase;

  AsmaUlHusnaCubit({required this.getAsmaUlHusnaUseCase})
    : super(AsmaUlHusnaInitial());

  Future<void> loadNames() async {
    emit(AsmaUlHusnaLoading());
    try {
      final names = await getAsmaUlHusnaUseCase.call();
      emit(AsmaUlHusnaLoaded(names: names));
    } catch (e) {
      emit(AsmaUlHusnaError(message: e.toString()));
    }
  }
}
