import 'package:flutter/material.dart';

sealed class ThemeState {
  const ThemeState();
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

final class ThemeChanged extends ThemeState {
  const ThemeChanged(this.mode);

  final ThemeMode mode;
}
