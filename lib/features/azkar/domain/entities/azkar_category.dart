import 'package:flutter/material.dart';
import 'package:sana/features/azkar/domain/entities/zikr.dart';

class AzkarCategory {
  final String id;
  final String title;
  final IconData icon;
  final List<Zikr> azkar;

  const AzkarCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.azkar,
  });
}
