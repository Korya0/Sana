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
    // Reloading is not strictly necessary if we just want to update sorting,
    // but for now let's keep it simple. Optimization: update local state.
    loadFeatures();
  }
}
