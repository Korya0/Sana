import 'package:flutter/material.dart';

@immutable
class AppState {
  const AppState({
    required this.themeMode,
    required this.keepScreenAwake,
  });

  final ThemeMode themeMode;
  final bool keepScreenAwake;

  AppState copyWith({
    ThemeMode? themeMode,
    bool? keepScreenAwake,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          keepScreenAwake == other.keepScreenAwake;

  @override
  int get hashCode => themeMode.hashCode ^ keepScreenAwake.hashCode;
}
