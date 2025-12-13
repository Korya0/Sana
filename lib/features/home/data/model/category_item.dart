import 'package:flutter/material.dart';
import 'package:sana/features/home/data/model/category_model.dart';

class CategoryItem implements CategoryModel {
  @override
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final Map<String, dynamic>? extra;
  final Future<void> Function(BuildContext)? onTap;

  CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.extra,
    this.onTap,
  });
}
