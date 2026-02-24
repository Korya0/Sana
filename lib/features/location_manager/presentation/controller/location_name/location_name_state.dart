import 'package:equatable/equatable.dart';

abstract class LocationNameState extends Equatable {
  const LocationNameState();
  @override
  List<Object?> get props => [];
}

class LocationNameInitial extends LocationNameState {}

class LocationNameLoading extends LocationNameState {}

class LocationNameLoaded extends LocationNameState {
  const LocationNameLoaded(this.location);
  final String location;

  @override
  List<Object?> get props => [location];
}

class LocationNameError extends LocationNameState {
  const LocationNameError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
