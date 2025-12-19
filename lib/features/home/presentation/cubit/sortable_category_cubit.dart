import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_state.dart';

abstract class SortableRepository<T> {
  Future<List<T>> getAllItems();
  Future<void> incrementUsage(String id);
}

class SortableCategoryCubit<T> extends Cubit<SortableCategoryState<T>> {
  final SortableRepository<T> _repository;

  SortableCategoryCubit(this._repository) : super(SortableCategoryInitial<T>());

  Future<void> loadFeatures() async {
    emit(SortableCategoryLoading<T>());
    try {
      final items = await _repository.getAllItems();
      emit(SortableFeaturesLoaded<T>(items));
    } catch (e) {
      emit(SortableCategoryError<T>(e.toString()));
    }
  }

  Future<void> incrementUsage(String id) async {
    await _repository.incrementUsage(id);
    // Performance Optimization:
    // We do NOT reload here using loadFeatures().
    // The sorting order remains stable during the session and updates only on next app launch/reload.
  }
}
