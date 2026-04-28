import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/data/repos/features_repository.dart';

part 'features_list_state.dart';

class FeaturesListCubit extends Cubit<FeaturesListState> {
  FeaturesListCubit(this._repository)
    : super(const FeaturesListInitial());
  final IFeaturesRepository _repository;

  void getFeatures() {
    emit(const FeaturesListLoading());
    _repository.getFeatures().when(
      success: (items) => emit(FeaturesListLoaded(items)),
      failure: (failure) => emit(FeaturesListError(failure.message)),
    );
  }
}
