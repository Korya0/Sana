import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

part 'asma_ul_husna_state.freezed.dart';

@freezed
class AsmaUlHusnaState with _$AsmaUlHusnaState {
  const factory AsmaUlHusnaState.initial() = AsmaUlHusnaInitial;
  const factory AsmaUlHusnaState.loading() = AsmaUlHusnaLoading;
  const factory AsmaUlHusnaState.loaded({
    required List<AsmaulHusnaModel> names,
  }) = AsmaUlHusnaLoaded;
  const factory AsmaUlHusnaState.error({required String message}) =
      AsmaUlHusnaError;
}
