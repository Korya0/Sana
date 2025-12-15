import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit() : super(AsmaUlHusnaInitial());

  Future<void> loadNames() async {
    emit(AsmaUlHusnaLoading());
    try {
      final names = await AsmaUlHusnaLocalDataSource.getNames();
      emit(AsmaUlHusnaLoaded(names: names));
    } catch (e) {
      emit(AsmaUlHusnaError(message: e.toString()));
    }
  }
}
