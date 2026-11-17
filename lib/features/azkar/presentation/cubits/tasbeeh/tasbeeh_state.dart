import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';

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
    final id = selectedItemId;
    if (id == null) return null;
    return items.byId(id);
  }

  // Returns selected index
  int? get selectedIndex {
    final id = selectedItemId;
    if (id == null) return null;
    return items.indexOfId(id);
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
