import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/cubit/app_state.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class AppCubit extends Cubit<AppState> {
  AppCubit(this._storageService)
      : super(
          const AppState(
            themeMode: ThemeMode.system,
            keepScreenAwake: true,
          ),
        ) {
    _loadSettings();
  }

  final ILocalStorageService _storageService;

  void _loadSettings() {
    final cachedTheme = _storageService.getString(StorageKeys.themeMode);
    final themeMode = cachedTheme != null
        ? ThemeMode.values.firstWhere(
            (e) => e.name == cachedTheme,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;

    final keepAwake =
        _storageService.getBoolean(StorageKeys.keepScreenAwake) ?? true;

    if (!kIsWeb) {
      if (keepAwake) {
        unawaited(WakelockPlus.enable());
      } else {
        unawaited(WakelockPlus.disable());
      }
    }

    emit(state.copyWith(themeMode: themeMode, keepScreenAwake: keepAwake));
  }


  Future<void> setThemeMode(ThemeMode mode) async {
    await _storageService.setString(StorageKeys.themeMode, mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleThemeMode() async {
    final nextMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storageService.setString(StorageKeys.themeMode, nextMode.name);
    emit(state.copyWith(themeMode: nextMode));
  }


  Future<void> toggleKeepScreenAwake() async {
    final newValue = !state.keepScreenAwake;
    await _storageService.setBoolean(StorageKeys.keepScreenAwake, newValue);

    if (!kIsWeb) {
      if (newValue) {
        unawaited(WakelockPlus.enable());
      } else {
        unawaited(WakelockPlus.disable());
      }
    }

    emit(state.copyWith(keepScreenAwake: newValue));
  }
}
