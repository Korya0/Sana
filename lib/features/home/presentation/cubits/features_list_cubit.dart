import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/data/repos/features_repository.dart';
import 'package:sana/core/network/result.dart';

part 'features_list_state.dart';

class FeaturesListCubit extends Cubit<FeaturesListState> {
  FeaturesListCubit(this._repository) : super(const FeaturesListInitial());
  final FeaturesRepository _repository;

  Future<void> getFeatures() async {
    emit(const FeaturesListLoading());
    final result = _repository.getFeatures();
    switch (result) {
      case Success(data: final items):
        emit(FeaturesListLoaded(items));
      case FailureResult(:final failure):
        emit(FeaturesListError(failure.message));
    }
  }
}
