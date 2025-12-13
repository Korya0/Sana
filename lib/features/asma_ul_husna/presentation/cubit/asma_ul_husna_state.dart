import 'package:equatable/equatable.dart';
import '../../domain/entities/asma_ul_husna.dart';

abstract class AsmaUlHusnaState extends Equatable {
  const AsmaUlHusnaState();

  @override
  List<Object> get props => [];
}

class AsmaUlHusnaInitial extends AsmaUlHusnaState {}

class AsmaUlHusnaLoading extends AsmaUlHusnaState {}

class AsmaUlHusnaLoaded extends AsmaUlHusnaState {
  final List<AsmaUlHusna> names;

  const AsmaUlHusnaLoaded({required this.names});

  @override
  List<Object> get props => [names];
}

class AsmaUlHusnaError extends AsmaUlHusnaState {
  final String message;

  const AsmaUlHusnaError({required this.message});

  @override
  List<Object> get props => [message];
}
