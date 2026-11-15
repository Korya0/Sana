import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

sealed class AzkarCategoriesState {
  // Creates state
  const AzkarCategoriesState();
}

class AzkarCategoriesInitial extends AzkarCategoriesState {}

class AzkarCategoriesLoading extends AzkarCategoriesState {}

class AzkarCategoriesLoaded extends AzkarCategoriesState {
  // Creates state
  const AzkarCategoriesLoaded(this.categories);

  final List<AzkarCategoryEntity> categories;
}

class AzkarCategoriesEmpty extends AzkarCategoriesState {}

class AzkarCategoriesError extends AzkarCategoriesState {
  // Creates state
  const AzkarCategoriesError(this.message);

  final String message;
}
