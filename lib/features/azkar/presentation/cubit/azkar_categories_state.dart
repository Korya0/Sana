import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

sealed class AzkarCategoriesState {
  const AzkarCategoriesState();
}

class AzkarCategoriesInitial extends AzkarCategoriesState {
  const AzkarCategoriesInitial();
}

class AzkarCategoriesLoading extends AzkarCategoriesState {
  const AzkarCategoriesLoading();
}

class AzkarCategoriesLoaded extends AzkarCategoriesState {
  const AzkarCategoriesLoaded(this.azkarCategories);
  final List<AzkarCategoryModel> azkarCategories;
}

class AzkarCategoriesError extends AzkarCategoriesState {
  const AzkarCategoriesError(this.message);
  final String message;
}
