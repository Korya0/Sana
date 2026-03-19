import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/features/quran/presentation/cubit/quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this._repo) : super(const QuranInitial());

  final IQuranRepo _repo;

  Future<void> init() async {
    if (state is QuranSuccess) return;

    emit(const QuranLoading());
    try {
      await _repo.initialize();
      emit(const QuranSuccess());
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Failed to initialize QuranLibrary',
          error: e,
          stackTrace: stack,
        ),
      );
      emit(QuranFailure(e.toString()));
    }
  }
}
