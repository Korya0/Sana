import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

@immutable
sealed class AzkarCategoriesState {
  const AzkarCategoriesState();
}

class AzkarCategoriesInitial extends AzkarCategoriesState {
  const AzkarCategoriesInitial();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AzkarCategoriesInitial;

  @override
  int get hashCode => 0;
}

class AzkarCategoriesLoading extends AzkarCategoriesState {
  const AzkarCategoriesLoading();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AzkarCategoriesLoading;

  @override
  int get hashCode => 1;
}

class AzkarCategoriesLoaded extends AzkarCategoriesState {
  const AzkarCategoriesLoaded(this.categories);
  final List<AzkarCategoryEntity> categories;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarCategoriesLoaded &&
          const ListEquality<AzkarCategoryEntity>().equals(categories, other.categories);

  @override
  int get hashCode => const ListEquality<AzkarCategoryEntity>().hash(categories);
}

class AzkarCategoriesError extends AzkarCategoriesState {
  const AzkarCategoriesError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarCategoriesError && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
