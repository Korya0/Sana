part of 'teaching_prayer_cubit.dart';

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
