import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/quran/presentation/cubit/quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this._quranRepo) : super(const QuranInitial());

  final IQuranRepo _quranRepo;

  Future<void> init() async {
    if (state is QuranSuccess) return;

    emit(const QuranLoading());
    final result = await _quranRepo.initialize();

    switch (result) {
      case Success():
        emit(const QuranSuccess());
      case FailureResult(:final failure):
        emit(QuranError(failure.message));
    }
  }
}
