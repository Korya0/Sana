import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

@immutable
sealed class AzkarCategoryLoaderState {
  const AzkarCategoryLoaderState();
}

class AzkarCategoryLoaderInitial extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderInitial();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AzkarCategoryLoaderInitial;

  @override
  int get hashCode => 0;
}

class AzkarCategoryLoaderLoading extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoading();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AzkarCategoryLoaderLoading;

  @override
  int get hashCode => 1;
}

class AzkarCategoryLoaderLoaded extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoaded(this.category);
  final AzkarCategoryEntity category;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarCategoryLoaderLoaded && category == other.category;

  @override
  int get hashCode => category.hashCode;
}

class AzkarCategoryLoaderError extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarCategoryLoaderError && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
