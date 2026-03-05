import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/data/repositories/features_repository.dart';

part 'features_list_state.dart';

class FeaturesListCubit extends Cubit<FeaturesListState> {
  FeaturesListCubit(this._repository) : super(FeaturesListInitial());
  final IFeaturesRepository _repository;

  void loadFeatures() {
    emit(FeaturesListLoading());
    final result = _repository.getFeatures();
    result.fold(
      (failure) => emit(FeaturesListError(failure.message)),
      (items) => emit(FeaturesListLoaded(items)),
    );
  }
}
