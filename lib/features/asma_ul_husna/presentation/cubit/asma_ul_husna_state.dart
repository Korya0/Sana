import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

sealed class AsmaUlHusnaState {
  const AsmaUlHusnaState();
}

class AsmaUlHusnaInitial extends AsmaUlHusnaState {
  const AsmaUlHusnaInitial();
}

class AsmaUlHusnaLoading extends AsmaUlHusnaState {
  const AsmaUlHusnaLoading();
}

class AsmaUlHusnaLoaded extends AsmaUlHusnaState {
  const AsmaUlHusnaLoaded({required this.names});
  final List<AsmaulHusnaModel> names;
}

class AsmaUlHusnaError extends AsmaUlHusnaState {
  const AsmaUlHusnaError({required this.message});
  final String message;
}
