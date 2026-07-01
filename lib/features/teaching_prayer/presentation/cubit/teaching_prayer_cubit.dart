import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/teaching_prayer/domain/repos/i_teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart';
import 'package:sana/core/networking/result.dart';

class TeachingPrayerCubit extends Cubit<TeachingPrayerState> {
  TeachingPrayerCubit(this._repository) : super(const TeachingPrayerInitial());

  final ITeachingPrayerRepository _repository;

  Future<void> loadSections() async {
    emit(const TeachingPrayerLoading());
    final result = await _repository.getSections();

    switch (result) {
      case Success(data: final sections):
        emit(TeachingPrayerSuccess(sections));
      case FailureResult(:final failure):
        emit(TeachingPrayerError(failure.message));
    }
  }
}
