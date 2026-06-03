import 'package:flutter/material.dart';

class ThemeState {
  const ThemeState({required this.themeMode});

  final ThemeMode themeMode;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
