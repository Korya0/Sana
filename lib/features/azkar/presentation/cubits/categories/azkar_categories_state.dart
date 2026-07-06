import 'package:sana/features/azkar/domain/entities/category_entity.dart';

sealed class AzkarCategoriesState {
  const AzkarCategoriesState();
}

class AzkarCategoriesInitial extends AzkarCategoriesState {}

class AzkarCategoriesLoading extends AzkarCategoriesState {}

class AzkarCategoriesLoaded extends AzkarCategoriesState {
  const AzkarCategoriesLoaded(this.categories);

  final List<CategoryEntity> categories;
}

class AzkarCategoriesEmpty extends AzkarCategoriesState {}

class AzkarCategoriesError extends AzkarCategoriesState {
  const AzkarCategoriesError(this.message);

  final String message;
}
