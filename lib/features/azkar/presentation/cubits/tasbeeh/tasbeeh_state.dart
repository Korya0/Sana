import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

@immutable
sealed class TasbeehState {
  // Creates state
  const TasbeehState();
}

class TasbeehInitial extends TasbeehState {}

class TasbeehLoading extends TasbeehState {}

class TasbeehError extends TasbeehState {
  // Creates state
  const TasbeehError(this.message);

  final String message;
}

class TasbeehLoaded extends TasbeehState {
  // Creates state
  const TasbeehLoaded({required this.items, this.selectedItemId});

  final List<TasbeehItemEntity> items;
  final String? selectedItemId;

  // Returns selected item
  TasbeehItemEntity? get selectedItem {
    if (selectedItemId == null) return null;
    for (final item in items) {
      if (item.id == selectedItemId) return item;
    }
    return null;
  }

  // Returns selected index
  int? get selectedIndex {
    if (selectedItemId == null) return null;
    for (var index = 0; index < items.length; index++) {
      if (items[index].id == selectedItemId) return index;
    }
    return null;
  }

  // Returns previous item
  TasbeehItemEntity? get previousItem {
    final index = selectedIndex;
    if (index == null || index <= 0) return null;
    return items[index - 1];
  }

  // Returns next item
  TasbeehItemEntity? get nextItem {
    final index = selectedIndex;
    if (index == null || index >= items.length - 1) return null;
    return items[index + 1];
  }

  // Checks reset
  bool get canResetSelected => selectedItem?.canReset ?? false;

  // Returns recent items
  List<TasbeehItemEntity> get recentItems {
    final sorted = List<TasbeehItemEntity>.of(items)
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return sorted;
  }

  // Copies state
  TasbeehLoaded copyWith({
    List<TasbeehItemEntity>? items,
    String? Function()? selectedItemId,
  }) => TasbeehLoaded(
    items: items ?? this.items,
    selectedItemId: selectedItemId != null
        ? selectedItemId()
        : this.selectedItemId,
  );
}
