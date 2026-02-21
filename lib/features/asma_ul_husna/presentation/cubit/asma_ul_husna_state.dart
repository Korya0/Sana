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

  const AsmaUlHusnaLoaded({required this.names});
  final List<AsmaulHusnaModel> names;

  @override
  List<Object> get props => [names];
}

class AsmaUlHusnaError extends AsmaUlHusnaState {

  const AsmaUlHusnaError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
