import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

@immutable
sealed class CustomAzkarState {
  // Creates state
  const CustomAzkarState();
}

class CustomAzkarInitial extends CustomAzkarState {
  // Creates state
  const CustomAzkarInitial();
}

class CustomAzkarLoading extends CustomAzkarState {
  // Creates state
  const CustomAzkarLoading();
}

class CustomAzkarLoaded extends CustomAzkarState {
  // Creates state
  const CustomAzkarLoaded(this.categories);

  final List<CustomCategoryEntity> categories;
}

class CustomAzkarEmpty extends CustomAzkarState {
  // Creates state
  const CustomAzkarEmpty();
}

class CustomAzkarError extends CustomAzkarState {
  // Creates state
  const CustomAzkarError(this.message);

  final String message;
}

class CustomAzkarOperationSuccess extends CustomAzkarState {
  // Creates state
  const CustomAzkarOperationSuccess(this.message);

  final String message;
}
