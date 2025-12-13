abstract class SortableCategoryState<T> {}

class SortableCategoryInitial<T> extends SortableCategoryState<T> {}

class SortableCategoryLoading<T> extends SortableCategoryState<T> {}

class SortableFeaturesLoaded<T> extends SortableCategoryState<T> {
  final List<T> items;
  SortableFeaturesLoaded(this.items);
}

class SortableCategoryError<T> extends SortableCategoryState<T> {
  final String message;
  SortableCategoryError(this.message);
}
