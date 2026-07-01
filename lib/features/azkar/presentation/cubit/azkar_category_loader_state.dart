import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

sealed class AzkarCategoryLoaderState {
  const AzkarCategoryLoaderState();
}

class AzkarCategoryLoaderInitial extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderInitial();
}

class AzkarCategoryLoaderLoading extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoading();
}

class AzkarCategoryLoaderLoaded extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoaded(this.category);
  final AzkarCategoryModel category;
}

class AzkarCategoryLoaderError extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderError(this.message);
  final String message;
}
