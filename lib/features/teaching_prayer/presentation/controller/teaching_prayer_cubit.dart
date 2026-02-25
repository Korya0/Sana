import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/teaching_prayer/data/repositories/teaching_prayer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

part 'teaching_prayer_state.dart';

// --- Cubit ---
class TeachingPrayerCubit extends Cubit<TeachingPrayerState> {
  TeachingPrayerCubit({required ITeachingPrayerRepository repository})
    : _repository = repository,
      super(TeachingPrayerInitial());
  final ITeachingPrayerRepository _repository;

  Future<void> loadSections() async {
    emit(TeachingPrayerLoading());
    final result = await _repository.getSections();
    result.fold(
      (failure) => emit(TeachingPrayerError(failure.message)),
      (sections) => emit(TeachingPrayerLoaded(sections)),
    );
  }
}
