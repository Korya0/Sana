import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/teaching_prayer/data/repos/teaching_prayer_repo_impl.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart';

class TeachingPrayerCubit extends Cubit<TeachingPrayerState> {
  TeachingPrayerCubit(this._repository) : super(const TeachingPrayerInitial());

  final ITeachingPrayerRepository _repository;

  Future<void> loadSections() async {
    emit(const TeachingPrayerLoading());
    final result = await _repository.getSections();

    result.when(
      success: (sections) => emit(TeachingPrayerSuccess(sections)),
      failure: (failure) => emit(
        TeachingPrayerError(
          failure.message,
        ),
      ),
    );
  }
}
