import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/home/data/model/category_model.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';

class SortableCategoryRepository<T extends CategoryModel>
    implements SortableRepository<T> {
  final Future<List<T>> Function() _dataSourceGetter;
  final String _prefKey;

  SortableCategoryRepository({
    required Future<List<T>> Function() dataSourceGetter,
    required String prefKey,
  }) : _dataSourceGetter = dataSourceGetter,
       _prefKey = prefKey;

  @override
  Future<List<T>> getAllItems() async {
    final items = await _dataSourceGetter();
    return _sortItems(items);
  }

  List<T> _sortItems(List<T> items) {
    final usageJson = SharedPref.preferences.getString(_prefKey);
    Map<String, int> usageMap = {};

    if (usageJson != null) {
      try {
        usageMap = Map<String, int>.from(json.decode(usageJson));
      } catch (e) {
        debugPrint('Error decoding usage: $e');
      }
    }

    // Create a list with original indices to maintain JSON order
    final itemsWithIndex = items.asMap().entries.map((entry) {
      return MapEntry(entry.key, entry.value);
    }).toList();

    itemsWithIndex.sort((a, b) {
      final usageA = usageMap[a.value.id] ?? 0;
      final usageB = usageMap[b.value.id] ?? 0;

      // If usage is different, sort by usage (descending)
      if (usageA != usageB) {
        return usageB.compareTo(usageA);
      }

      // If usage is the same, maintain original JSON order (ascending index)
      return a.key.compareTo(b.key);
    });

    return itemsWithIndex.map((e) => e.value).toList();
  }

  @override
  Future<void> incrementUsage(String id) async {
    final usageJson = SharedPref.preferences.getString(_prefKey);
    Map<String, int> usageMap = {};

    if (usageJson != null) {
      try {
        usageMap = Map<String, int>.from(json.decode(usageJson));
      } catch (e) {
        debugPrint('Error decoding usage: $e');
      }
    }

    usageMap[id] = (usageMap[id] ?? 0) + 1;
    await SharedPref.preferences.setString(_prefKey, json.encode(usageMap));
  }
}
