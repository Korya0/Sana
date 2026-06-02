import 'package:flutter/material.dart';

class AppState {
  const AppState({required this.themeMode});

  final ThemeMode themeMode;

  AppState copyWith({ThemeMode? themeMode}) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
