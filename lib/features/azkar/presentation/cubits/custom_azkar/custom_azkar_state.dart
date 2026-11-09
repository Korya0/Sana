import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

@immutable
sealed class CustomAzkarState {
  const CustomAzkarState();
}

class CustomAzkarInitial extends CustomAzkarState {
  const CustomAzkarInitial();
}

class CustomAzkarLoading extends CustomAzkarState {
  const CustomAzkarLoading();
}

class CustomAzkarLoaded extends CustomAzkarState {
  const CustomAzkarLoaded(this.categories);

  final List<CustomCategoryEntity> categories;
}

class CustomAzkarEmpty extends CustomAzkarState {
  const CustomAzkarEmpty();
}

class CustomAzkarError extends CustomAzkarState {
  const CustomAzkarError(this.message);

  final String message;
}

class CustomAzkarOperationSuccess extends CustomAzkarState {
  const CustomAzkarOperationSuccess(this.message);

  final String message;
}

