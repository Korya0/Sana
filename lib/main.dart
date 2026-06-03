import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sana/core/app/cubit/app_cubit.dart';
import 'package:sana/core/app/cubit/app_state.dart';
import 'package:sana/core/common/layout/responsive_wrapper.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:sana/core/services/app_update/presentation/widgets/update_overlay.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/core/utils/context_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    // Dont touch this
    kIsWeb && kDebugMode
        ? DevicePreview(
            builder: (context) => const SanaApp(),
          )
        : const SanaApp(),
  );
  unawaited(initializeAppPostFrame());
}

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AppCubit>()),
        BlocProvider(create: (context) => sl<LocationCubit>()),
        BlocProvider(create: (context) => sl<AppUpdateCubit>()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: AppRouter.router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale(AppConstants.ar),
            ],
            locale: const Locale(AppConstants.ar),
            builder: (context, child) {
              return ResponsiveWrapper(
                onOutsideTap: () {
                  unawaited(AppRouter.navigatorKey.currentState?.maybePop());
                },
                child: MediaQuery(
                  data: context.noScalingMediaQuery,
                  child: GestureDetector(
                    onTap: context.unfocus,
                    child: Stack(
                      children: [
                        child!,
                        const UpdateOverlay(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
