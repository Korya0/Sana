import 'package:equatable/equatable.dart';

abstract class LocationNameState extends Equatable {
  const LocationNameState();
  @override
  List<Object?> get props => [];
}

class LocationNameInitial extends LocationNameState {}

class LocationNameLoading extends LocationNameState {}

class LocationNameLoaded extends LocationNameState {
  final String location;
  const LocationNameLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class LocationNameError extends LocationNameState {
  final String message;
  const LocationNameError(this.message);

  @override
  List<Object?> get props => [message];
}
