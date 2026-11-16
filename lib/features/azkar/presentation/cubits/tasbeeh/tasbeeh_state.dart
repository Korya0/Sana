import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

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
  const TasbeehLoaded({required this.items, this.selectedId});

  final List<TasbeehItemEntity> items;
  final String? selectedId;

  // Returns selected item
  TasbeehItemEntity? get selectedItem {
    if (selectedId == null) return null;
    for (final item in items) {
      if (item.id == selectedId) return item;
    }
    return null;
  }

  // Returns recent items
  List<TasbeehItemEntity> get recentItems {
    final sorted = List<TasbeehItemEntity>.of(items)
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return sorted;
  }

  // Copies state
  TasbeehLoaded copyWith({
    List<TasbeehItemEntity>? items,
    String? Function()? selectedId,
  }) => TasbeehLoaded(
    items: items ?? this.items,
    selectedId: selectedId != null ? selectedId() : this.selectedId,
  );
}
