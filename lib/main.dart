import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sana/core/common/layout/responsive_wrapper.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:sana/core/services/app_update/presentation/widgets/update_overlay.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/theme/cubit/theme_cubit.dart';
import 'package:sana/core/theme/cubit/theme_state.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<ThemeCubit>()),
          BlocProvider(create: (context) => sl<LocationCubit>()),
          BlocProvider(create: (context) => sl<AppUpdateCubit>()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.light,
              //state.themeMode
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
                return SkeletonizerConfig(
                  data: SkeletonizerConfigData(
                    effect: ShimmerEffect(
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                      baseColor: Colors.grey.withValues(alpha: 0.3),
                      highlightColor: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ResponsiveWrapper(
                    onOutsideTap: () {
                      unawaited(
                        AppRouter.navigatorKey.currentState?.maybePop(),
                      );
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
