import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/di/features/azkar_di.dart';
import 'package:sana/core/di/features/qibla_di.dart';
import 'package:sana/core/di/features/quran_di.dart';
import 'package:sana/core/utils/app_bloc_observer.dart';

final class AppInitializer {
  AppInitializer._();

  /// Initializes the app.
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // System bar color
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Portrait only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Dependency injection
    await setupCoreDependencies(sl);
    setupAzkarDependencies(sl);
    setupQiblaDependencies(sl);
    setupQuranDependencies(sl);

    // Bloc observer
    Bloc.observer = const AppBlocObserver();
  }
}
