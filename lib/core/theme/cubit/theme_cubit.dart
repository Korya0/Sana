import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/theme/cubit/theme_state.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._storageService)
    : super(const ThemeState(themeMode: ThemeMode.system)) {
    _loadThemeMode();
  }

  final ILocalStorageService _storageService;

  void _loadThemeMode() {
    final cachedTheme = _storageService.getString(StorageKeys.themeMode);
    if (cachedTheme != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.name == cachedTheme,
        orElse: () => ThemeMode.system,
      );
      emit(state.copyWith(themeMode: mode));
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storageService.setString(StorageKeys.themeMode, mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleThemeMode() async {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _storageService.setString(StorageKeys.themeMode, nextMode.name);
    emit(state.copyWith(themeMode: nextMode));
  }
}
