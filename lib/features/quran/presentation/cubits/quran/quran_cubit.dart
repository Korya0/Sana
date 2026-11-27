import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/quran/domain/use_cases/initialize_quran_use_case.dart';
import 'package:sana/features/quran/presentation/cubits/quran/quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit({required InitializeQuranUseCase initializeQuran})
      : _initializeQuran = initializeQuran,
        super(const QuranInitial());

  final InitializeQuranUseCase _initializeQuran;

  // Initialize
  Future<void> initialize() async {
    if (isClosed || state is! QuranInitial) return;

    emit(const QuranLoading());
    final result = await _initializeQuran();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const QuranReady());
      case FailureResult(:final failure):
        emit(QuranFailed(failure.message));
    }
  }

  // Retry
  Future<void> retry() async {
    if (isClosed) return;
    emit(const QuranInitial());
    await initialize();
  }
}
