import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/quran/domain/use_cases/initialize_quran_use_case.dart';
import 'package:sana/features/quran/presentation/cubit/quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this._initializeQuranUseCase) : super(const QuranInitial());

  final InitializeQuranUseCase _initializeQuranUseCase;

  Future<void> init() async {
    if (state is QuranSuccess) return;

    emit(const QuranLoading());
    final result = await _initializeQuranUseCase();

    result.when(
      success: (_) => emit(const QuranSuccess()),
      failure: (failure) => emit(QuranError(failure.message)),
    );
  }
}
