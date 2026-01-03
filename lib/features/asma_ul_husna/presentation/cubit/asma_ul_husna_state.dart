import 'package:equatable/equatable.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

abstract class AsmaUlHusnaState extends Equatable {
  const AsmaUlHusnaState();

  @override
  List<Object> get props => [];
}

class AsmaUlHusnaInitial extends AsmaUlHusnaState {}

class AsmaUlHusnaLoading extends AsmaUlHusnaState {}

class AsmaUlHusnaLoaded extends AsmaUlHusnaState {
  final List<AsmaulHusnaModel> names;

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
