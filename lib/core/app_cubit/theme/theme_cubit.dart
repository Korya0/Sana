import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/app_cubit/theme/theme_state.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/services/local_storage/app_local_storage.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';

final class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._storage) : super(const ThemeInitial());

  final AppLocalStorage _storage;

  ThemeMode get currentMode => switch (state) {
    ThemeInitial() => ThemeMode.system,
    ThemeChanged(:final mode) => mode,
  };

  /// Loads saved theme.
  void loadSavedTheme() {
    final saved = _storage.read<String>(AppStorageKeys.themeMode);
    final mode = switch (saved) {
      AppConstants.themeLight => ThemeMode.light,
      AppConstants.themeDark => ThemeMode.dark,
      AppConstants.themeSystem => ThemeMode.system,
      _ => ThemeMode.system,
    };
    emit(ThemeChanged(mode));
  }

  /// Saves and emits mode.
  Future<void> changeTheme(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => AppConstants.themeLight,
      ThemeMode.dark => AppConstants.themeDark,
      ThemeMode.system => AppConstants.themeSystem,
    };
    await _storage.write(AppStorageKeys.themeMode, value);
    emit(ThemeChanged(mode));
  }

  /// Toggles light and dark.
  Future<void> toggleTheme() async {
    final next = switch (currentMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await changeTheme(next);
  }
}
