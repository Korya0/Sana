import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/teaching_prayer/data/repos/teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart';

// --- Cubit ---
class TeachingPrayerCubit extends Cubit<TeachingPrayerState> {
  TeachingPrayerCubit({required ITeachingPrayerRepository repository})
    : _repository = repository,
      super(const TeachingPrayerState.initial());
  final ITeachingPrayerRepository _repository;

  Future<void> loadSections() async {
    emit(const TeachingPrayerState.loading());
    final result = await _repository.getSections();
    result.when(
      success: (sections) => emit(TeachingPrayerState.loaded(sections)),
      failure: (failure) => emit(TeachingPrayerState.error(failure.message)),
    );
  }
}
