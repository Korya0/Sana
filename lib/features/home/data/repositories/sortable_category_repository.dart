import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/home/data/model/category_model.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';

class SortableCategoryRepository<T extends CategoryModel>
    implements SortableRepository<T> {
  final Future<List<T>> Function() _dataSourceGetter;
  final String _prefKey;

  // Cache to store items and usage in memory
  List<T>? _cachedItems;
  Map<String, int>? _cachedUsage;

  SortableCategoryRepository({
    required Future<List<T>> Function() dataSourceGetter,
    required String prefKey,
  }) : _dataSourceGetter = dataSourceGetter,
       _prefKey = prefKey;

  @override
  Future<List<T>> getAllItems() async {
    // Valid cache? return immediately
    if (_cachedItems != null) {
      return _cachedItems!;
    }

    final items = await _dataSourceGetter();
    _loadUsageFromDisk();

    // Sort and cache
    _cachedItems = _sortItems(items);
    return _cachedItems!;
  }

  void _loadUsageFromDisk() {
    if (_cachedUsage != null) return;

    final usageJson = SharedPref.preferences.getString(_prefKey);
    if (usageJson != null) {
      try {
        _cachedUsage = Map<String, int>.from(json.decode(usageJson));
      } catch (e) {
        debugPrint('Error decoding usage: $e');
        _cachedUsage = {};
      }
    } else {
      _cachedUsage = {};
    }
  }

  List<T> _sortItems(List<T> items) {
    final usageMap = _cachedUsage ?? {};

    // Create a list with original indices to maintain stable sort for equal usage
    final itemsWithIndex = items.asMap().entries.map((entry) {
      return MapEntry(entry.key, entry.value);
    }).toList();

    itemsWithIndex.sort((a, b) {
      final usageA = usageMap[a.value.id] ?? 0;
      final usageB = usageMap[b.value.id] ?? 0;

      // Descending usage
      if (usageA != usageB) {
        return usageB.compareTo(usageA);
      }

      // Ascending original index (stable sort)
      return a.key.compareTo(b.key);
    });

    return itemsWithIndex.map((e) => e.value).toList();
  }

  @override
  Future<void> incrementUsage(String id) async {
    // Ensure usage map is initialized
    if (_cachedUsage == null) _loadUsageFromDisk();

    // Update in-memory
    _cachedUsage![id] = (_cachedUsage![id] ?? 0) + 1;

    // Persist in background (Fire-and-forget for performance)
    _persistUsage();
  }

  Future<void> _persistUsage() async {
    try {
      if (_cachedUsage != null) {
        await SharedPref.preferences.setString(
          _prefKey,
          json.encode(_cachedUsage),
        );
      }
    } catch (e) {
      debugPrint('Error saving usage: $e');
    }
  }
}
