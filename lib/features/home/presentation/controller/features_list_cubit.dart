import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/data/repositories/features_repository.dart';

part 'features_list_cubit.freezed.dart';
part 'features_list_state.dart';

class FeaturesListCubit extends Cubit<FeaturesListState> {
  FeaturesListCubit(this._repository)
    : super(const FeaturesListState.initial());
  final IFeaturesRepository _repository;

  void loadFeatures() {
    emit(const FeaturesListState.loading());
    _repository.getFeatures().when(
      success: (items) => emit(FeaturesListState.loaded(items)),
      failure: (failure) => emit(FeaturesListState.error(failure.message)),
    );
  }
}
