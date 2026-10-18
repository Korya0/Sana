import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/utils/app_bloc_observer.dart';

final class AppInitializer {
  AppInitializer._();

  /// Initializes the app.
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Hide navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await setupCoreDependencies(sl);

    Bloc.observer = const AppBlocObserver();
  }
}
