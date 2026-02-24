import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/data/repositories/teaching_prayer_repository.dart';

// --- State ---
abstract class TeachingPrayerState extends Equatable {
  const TeachingPrayerState();

  @override
  List<Object?> get props => [];
}

class TeachingPrayerInitial extends TeachingPrayerState {}

class TeachingPrayerLoading extends TeachingPrayerState {}

class TeachingPrayerLoaded extends TeachingPrayerState {
  const TeachingPrayerLoaded(this.sections);
  final List<TeachingPrayerSection> sections;

  @override
  List<Object?> get props => [sections];
}

class TeachingPrayerError extends TeachingPrayerState {
  const TeachingPrayerError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// --- Cubit ---
class TeachingPrayerCubit extends Cubit<TeachingPrayerState> {
  TeachingPrayerCubit(this._repository) : super(TeachingPrayerInitial());
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
