import 'package:flutter/material.dart';

class AzkarListScreen extends StatelessWidget {
  const AzkarListScreen({required this.categoryId, super.key});
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Azkar List Screen: $categoryId')),
    );
  }
}
